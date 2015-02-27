marker "recipe_start"

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.server_live_migrate.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
TAG_BRICK_NUM = node[:glusterfs][:tag][:bricknum]
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
IP_ADDR    = node[:cloud][:private_ips][0]
BRICK_NUM  = node[:glusterfs][:server][:replace_brick].to_s

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{IP_ADDR}:#{EXPORT_DIR}"

  # Find all other spares and so we can add them to the trusted pool
  find_all_spares "find_spares" do
    tags "#{TAG_SPARE}=true"
    secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
  end
Chef::Log.info "SPARES: #{node[:glusterfs][:server][:spares].first}"

spare_ip = "#{node[:glusterfs][:server][:spares].first}"

if spare_ip.to_s == ""
  raise ::Chef::Exceptions::Application, "No spares detected, failing!"
end

#Grab uuid of spare
#spare_uuid = "rs_tag.rb --list  -q \"server:private_ip_0=#{spare_ip}\"|grep uuid|tr -d '[ ,\"]'"
spare_tags = "rs_tag -f yaml -q 'server:private_ip_0=#{spare_ip}'"
spare_uuid = "server:uuid=" + `#{spare_tags} |grep 'uuid'|cut -f2 -d=`.chomp



# Find an existing host in the pool so he can invite us

find_attached_peer "find_peer" do
#  tags "#{TAG_ATTACH}=true"
  tags "#{TAG_BRICK_NUM}=#{BRICK_NUM}"
  secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
end

peer_ip = node[:glusterfs][:server][:peer]

if peer_ip.to_s == ""
  raise ::Chef::Exceptions::Application, "No peer ip returned, error."
end

Chef::Log.info "UUID: #{node[:glusterfs][:server][:peer_uuid_tag]}"
Chef::Log.info "PEER IP: #{peer_ip}"

# raise ::Chef::Exceptions::Application, "Debug: testing"

# Run remote recipe on attached node 
peer_uuid = node[:glusterfs][:server][:peer_uuid_tag]
if ! peer_uuid.empty?
  log "===> Running remote recipe on attached peer"
  remote_recipe "Handle our probe request" do
    recipe "glusterfs::server_handle_probe_request"
    attributes :glusterfs => {
      :server => {
       :peer => spare_ip
      }
    }
    recipients_tags peer_uuid #server:uuid
  end

  # Wait for probe request to complete
  bash "Wait for peer status" do
    code <<-EOF
      echo "  Waiting 2 min max"
      i=0
      while [ $i -lt 120 ]
      do
          if gluster peer status \
              |grep -Gqx 'State: Peer in Cluster (Connected)'
          then
              echo "===> Ok! We're joined!!"
              exit 0
          fi
          echo "  Waiting..."
          i=`expr $i + 5`
          sleep 5
      done
      echo '!!!> ERROR: Probe request failed after 120 seconds'
      exit 1
    EOF
  end


#Run remote recipe of peer to migrate brick off
if ! spare_ip.empty?
  log "===> Running remote recipe on attached peer"
  rsc_remote_recipe "start live migration" do
    recipe "glusterfs::server_handle_live_migration"
    attributes :glusterfs => {
      :server => {
        :peer => peer_ip,
        :forced =>  node[:glusterfs][:server][:replace_brick_forced]
      }
    }
    recipients_tags spare_uuid #server:uuid
  end
end


else
  raise "!!!> No existing GlusterFS servers found for this volume!"
end
