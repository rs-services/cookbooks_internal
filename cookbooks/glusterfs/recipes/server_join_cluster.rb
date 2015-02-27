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
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
IP_ADDR    = node[:cloud][:private_ips][0]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{IP_ADDR}:#{EXPORT_DIR}"

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

if VOL_TYPE == "Replicated"
  # Find all other spares and so we can add them to the trusted pool
  find_all_spares "find_spares" do
    tags "#{TAG_SPARE}=true"
    secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
  end
  #Chef::Log.info "SPARES: #{node[:glusterfs][:server][:spares].inspect}"

  # Consider replica_count for replicated volume types
  # (maybe we can't use ALL the spares, since the number of bricks we need must
  # be a factor of replica_count)
  prune_spares "factor_by_replica_count" do 
    replica_count REPL_COUNT
    myip IP_ADDR
  end
  #Chef::Log.info "PRUNED: #{node[:glusterfs][:server][:spares].inspect}"
else
  # If this isn't a replicated volume, then we're the only spare
  # (only want to add ourself and our brick to the pool)
  node[:glusterfs][:server][:spares] = [IP_ADDR]
end

# Find an existing host in the pool so he can invite us
find_attached_peer "find_peer" do
  tags "#{TAG_ATTACH}=true"
  secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
end
#Chef::Log.info "UUID: #{node[:glusterfs][:server][:peer_uuid_tag]}"

# Run remote recipe on attached node 
peer_uuid = node[:glusterfs][:server][:peer_uuid_tag]
if ! peer_uuid.empty?
  log "===> Running remote recipe on attached peer"
  remote_recipe "Handle our probe request" do
    recipe "glusterfs::server_handle_probe_request"
    attributes :glusterfs => {
      :server => {
        :peer => IP_ADDR
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

  # Now that we're joined, let's add the other spares if we need to
  if VOL_TYPE == "Replicated"
    gluster_peer_probe "spares" do
        peers node[:glusterfs][:server][:spares] 
    end
  end

  # Add everyone's 
  ruby_block "gluster volume add-brick" do
    block do
      Chef::Log.info "===> Adding brick(s) to volume '#{VOL_NAME}'"

      # Build the command...
      cmd = "gluster volume add-brick #{VOL_NAME}"
      node[:glusterfs][:server][:spares].each do |ip|
        # FIXME query tags and use exact brick name from each host
        # (theoretically each server could have a unique export/brick name)
        cmd += " #{ip}:#{EXPORT_DIR}"
      end

      # Run the command
      result = ""
      IO.popen("#{cmd}") { |gl_io| result = gl_io.gets.chomp }
      if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
      end
      GlusterFS::Error.check(CMD_LOG, "Adding bricks")
    end
  end

  # Remove TAG_SPARE from hosts and add TAG_ATTACH
  #
  # (the remote recipe being invoked is intelligent and only removes the tag if
  # its brick is in fact part of the volume, thus safe to run on all hosts.)
  log "===> Running remote recipes to update tags"
  remote_recipe "update_tags" do
    recipe "glusterfs::server_handle_tag_updates"
    recipients_tags "#{TAG_SPARE}=true"
  end

else
  raise "!!!> No existing GlusterFS servers found for this volume!"
end
