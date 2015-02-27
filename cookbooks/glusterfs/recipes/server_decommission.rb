marker "recipe_start"

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
IP_ADDR    = node[:cloud][:private_ips][0]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{IP_ADDR}:#{EXPORT_DIR}"

# Check if we actually have any peers
# (could also check the tags, but this is more definitive)
#
sh = bash "Check peer status" do
  code <<-EOF
    if ! gluster peer status |grep -Gqx 'State: Peer in Cluster (Connected)'
    then
        echo "!!!> This host doesn't have any peers!"
        echo "!!!> Exiting."
        exit 1
    fi
  EOF
  action :nothing
end
sh.run_action(:run)

# Remove our brick from the volume
#
# TODO How to handle decomissioning a node from replicated volume ?
#      Needs to run a remote recipe that takes out other nodes as well?
#      Maybe there should be a decomm_safety input? How do you determine which
#      nodes get removed?  Maybe an optional input for specifying?
#
log "===> Removing brick from volume"
ruby_block "gluster volume remove-brick" do
  block do
    result = ""
    IO.popen("yes | gluster volume remove-brick #{VOL_NAME} #{BRICK_NAME}") { |gl_io| result = gl_io.gets.chomp }
    if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
    end
    GlusterFS::Error.check(CMD_LOG, "Removing brick from volume '#{VOL_NAME}'")
  end
  only_if "gluster volume info #{VOL_NAME} | grep -Gqw #{BRICK_NAME}"
end

 ruby_block "searching master tags" do
    block do
      tags = tag_search(node,"#{TAG_ATTACH}=true} #{TAG_VOLUME}=#{VOL_NAME}").first

      Chef::Log.info "Master IP: " + tags["server:private_ip_0"].first.value
      Chef::Log.info "Master Hostname: " + tags["server:uuid="].first.value
    end
  end

#  node.override[:glusterfs][:server][:peer_uuid_tag] = tags.detect do |u|
#          u =~ /^server:uuid=/
#        end
#Chef::Log.info "UUID: #{node[:glusterfs][:server][:peer_uuid_tag]}"
peer_uuid = node[:glusterfs][:server][:peer_uuid_tag]

if ! peer_uuid.empty?
  log "===> Running remote recipe on attached peer"
  rsc_remote_recipe "glusterfs::server_handle_detach_request" do
    recipe "glusterfs::server_handle_detach_request"
    attributes :glusterfs => {
      :server => {
        :peer => IP_ADDR
      }
    }
    recipients_tags peer_uuid #server:uuid
  end

  bash "Wait for detach" do
    code <<-EOF
      echo "  Waiting 2 min max"
      i=0
      while [ $i -lt 120 ]
      do
          if gluster peer status | grep -qxi 'no peers present'
          then
              echo "===> Ok! Detached!!"
              exit 0
          fi
          echo "  Waiting..."
          i=`expr $i + 5`
          sleep 5
      done
      echo '!!!> ERROR: Detach request failed after 120 seconds'
      exit 1
    EOF
  end
else
  raise "!!!> MELTDOWN: There are no other servers tagged with #{TAG_ATTACH}=true and #{TAG_VOLUME}=#{VOL_NAME}, yet we are peered with someone else?!! Giving up."
end

# Reset the tags
#
log "===> Deleting tag #{TAG_ATTACH}=true"
machine_tag "#{TAG_ATTACH}=true" do
  action :delete
end

log "===> Adding tag #{TAG_SPARE}=true"
machine_tag "#{TAG_SPARE}=true" do
  action :create
end
