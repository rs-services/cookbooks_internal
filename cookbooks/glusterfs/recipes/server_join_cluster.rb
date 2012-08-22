rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
#
EXPORT_DIR = node[:glusterfs][:server][:storage_path]
BRICK_NAME = "#{node[:cloud][:private_ips][0]}:#{EXPORT_DIR}"
VOL_NAME   = node[:glusterfs][:volume_name]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_SPARE  = node[:glusterfs][:tag][:spare]

# FIXME Apparently there's no supported/native way to fetch tags with the
#       RightLink `right_link_tag' resource. I sleuthed the provider code and
#       it does define action_load(), which populates node[], but apparently 
#       it can't be called from a recipe successfully:
#
#           Unexpected response
#           ["glusterfs_server:brick=/mnt/ephemeral/glusterfs",
#           "glusterfs_server:spare=true", "glusterfs_server:volume=foooo",
#           "rs_agent_dev:download_cookbooks_once=true",
#           "rs_login:state=restricted", "rs_monitoring:state=active",
#           "server:private_ip_0=10.240.186.96",
#           "server:public_ip_0=108.59.86.103", "server:uuid=01-1E06IT8"]
#           Failed to load msgpack data (undefined method `getbyte' for
#           #<Array:0x7f810fc6cf18>):
#           ["glusterfs_server:brick=/mnt/ephemeral/glusterfs",
#           "glusterfs_server:spare=true", "glusterfs_server:volume=foooo",
#           "rs_agent_dev:download_cookbooks_once=true",
#           "rs_login:state=restricted", "rs_monitoring:state=active",
#           "server:private_ip_0=10.240.186.96",
#           "server:public_ip_0=108.59.86.103", "server:uuid=01-1E06IT8"]
#
#       so we just shell out to rs_tag like White does:
#
check_attached = `rs_tag --list | grep '"#{TAG_ATTACH}=true"'`
if ! check_attached.empty?
  raise "This server thinks it is already attached! (#{TAG_ATTACH}=true)"
end

# TODO Find other spares if we need to, based on REPL_COUNT, and add them as
#      bricks
#
# TODO The following two resources should be a definition (since they are used
#      identically in server_handle_detach_request), but I'm not sure how you
#      force a definition to run in the compile phase (maybe the same way you
#      do for any normal resource).
#
# find all servers marked as 'attached' (joined to the cluster)
sc = rightscale_server_collection "glusterfs_attached" do
  tags "#{TAG_ATTACH}=true"
  secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
  action :nothing
end
sc.run_action(:load)

# grab the uuid of the first one (doesn't matter which one we use)
peer_uuid = ""
rb = ruby_block "geet peer uuid" do
  block do
    node[:server_collection]["glusterfs_attached"].each do |id, tags|
      peer_uuid = tags.detect { |u| u =~ /^server:uuid=/ }
      ip_tag = tags.detect { |i| i =~ /^server:private_ip_0=/ }
      ip = ip_tag.gsub(/^.*=/, '')
      Chef::Log.info "===> Found attached peer #{ip}"
      break # only need one host
    end
  end
end
rb.run_action(:create)

if ! peer_uuid.empty?
  log "===> Running remote recipe on attached peer"
  remote_recipe "Handle our probe request" do
    recipe "glusterfs::server_handle_probe_request"
    attributes :glusterfs => {
      :server => {
        :peer => node[:cloud][:private_ips][0]
      }
    }
    recipients_tags peer_uuid #server:uuid
  end

  # Wait for peer to probe us (so humiliating)
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

  bash "gluster volume add-brick" do
    code <<-EOF
      gluster volume add-brick #{VOL_NAME} #{BRICK_NAME} &> #{CMD_LOG}
      if grep -qwi successful #{CMD_LOG}
      then
          echo "===> Brick successfully added to volume '#{VOL_NAME}'"
          rm -f #{CMD_LOG}
          exit 0
      else
          echo "!!!> Add-brick command failed: "
          cat #{CMD_LOG} && rm -f #{CMD_LOG}
          exit 1
      fi
    EOF
  end

  right_link_tag "#{TAG_ATTACH}=true" do
    action :publish
  end

  right_link_tag "#{TAG_SPARE}=true" do
    action :remove
  end

else
  raise "!!!> No existing GlusterFS servers found for this volume!"
end

rightscale_marker :end
