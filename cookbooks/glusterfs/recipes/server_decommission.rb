rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
VOL_NAME   = node[:glusterfs][:volume_name]
IP_ADDR    = node[:cloud][:private_ips][0]
EXPORT_DIR = node[:glusterfs][:server][:storage_path]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
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
# TODO How to handle decomissioning a node when REPL_COUNT > 1 ?
#      Needs to run a remote recipe that takes out other nodes as well?
#      Maybe there should be a decomm_safety input? How do you determine which
#      nodes get removed?  Maybe an optional input for specifying?
#
log "===> Removing brick from volume"
ruby_block "gluster volume remove-brick" do
  block do
    system "yes | gluster volume remove-brick \
      #{VOL_NAME} #{BRICK_NAME} &> #{CMD_LOG}"
    GlusterFS::Error.check(CMD_LOG, "Removing brick from volume '#{VOL_NAME}'")
  end
  only_if "gluster volume info #{VOL_NAME} | grep -Gqw #{BRICK_NAME}"
end

# TODO The following two resources should be a definition (since they are used
#      identically in server_join_cluster), but I'm not sure how you force a
#      definition to run in the compile phase (maybe the same way you do for
#      any normal resource).
#
# Find servers marked as 'attached' (joined to the cluster)
#
sc = rightscale_server_collection "glusterfs_attached" do
  tags "#{TAG_ATTACH}=true"
  secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
  action :nothing
end
sc.run_action(:load)

# Grab the uuid tag of one server so we can remote-recipe it
#
peer_uuid = ""
rb = ruby_block "geet peer uuid" do
  block do
    node[:server_collection]["glusterfs_attached"].each do |id, tags|
      ip_tag = tags.detect { |i| i =~ /^server:private_ip_0=/ }
      ip = ip_tag.gsub(/^.*=/, '')
      next if ip == IP_ADDR   # skip ourself (can't detach ourself)
      Chef::Log.info "===> Found attached peer #{ip}"
      peer_uuid = tags.detect { |u| u =~ /^server:uuid=/ }
      break # only need one host
    end
  end
end
rb.run_action(:create)

if ! peer_uuid.empty?
  log "===> Running remote recipe on attached peer"
  remote_recipe "Handle our detach request" do
    recipe "glusterfs::server_handle_detach_request"
    attributes :glusterfs => {
      :server => {
        :peer => node[:cloud][:private_ips][0]
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
right_link_tag "#{TAG_ATTACH}=true" do
  action :remove
end

log "===> Adding tag #{TAG_SPARE}=true"
right_link_tag "#{TAG_SPARE}=true" do
  action :publish
end

rightscale_marker :end
