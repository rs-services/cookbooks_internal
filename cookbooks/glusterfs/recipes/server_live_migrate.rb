rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
TAG_BRICK_NUM = node[:glusterfs][:tag][:bricknum]
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
IP_ADDR    = node[:cloud][:private_ips][0]
BRICK_NUM  = node[:glusterfs][:server][:replace_brick]
TAG_ATTACH = node[:glusterfs][:tag][:attached]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp

if node[:glusterfs][:server][:replace_brick].to_s == ""
  Chef::Application.fatal!("No brick specified to replace!")
end

# Find all other spares so we can create a trusted pool
find_all_spares "find_spares" do
  tags "#{TAG_SPARE}=true"
  secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
end
#Chef::Log.info "SPARES: #{node[:glusterfs][:server][:spares].inspect}"

if node[:glusterfs][:server][:spares].to_s == ""
  Chef::Application.fatal!("No spare servers to replicate brick to!")
end

new_brick_peer = node[:glusterfs][:server][:spares].first

# Find an existing host in the pool so he can invite us
find_attached_peer "find_peer" do
  tags [ "#{TAG_ATTACH}=true", "#{TAG_BRICK_NUM}=#{BRICK_NUM}" ]
    secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
end

if node[:glusterfs][:server][:peers].to_s == ""
  Chef::Application.fatal!("No peer servers to replicate brick from, found!")
end


old_brick_peer = node[:glusterfs][:server][:peers].first

# Consider replica_count for replicated volume types
# (maybe we can't use ALL the spares, since the number of bricks we need must
# be a factor of replica_count)

# Probe the first peer
# Create a trusted pool from the IPs we have
gluster_peer_probe "spares" do
  peers new_brick_peer
end

    # Build the command...
    cmd = "gluster volume replace-brick #{VOL_NAME} #{old_brick_peer[:ip]}:#{EXPORT_DIR} #{new_brick_peer[:ip]}:#{EXPORT_DIR} start"

    # Run the command
    system "#{cmd} &> #{CMD_LOG}"
    GlusterFS::Error.check(CMD_LOG, "Started")

    # Set some options on the volume
    Chef::Log.info "===> Migratingvolume."


## Remove TAG_SPARE from hosts and add TAG_ATTACH
#
# (the remote recipe being invoked is intelligent and only removes the tag if
# its brick is in fact part of the volume, thus safe to run on all hosts.)
log "===> Running remote recipes to update tags"
remote_recipe "update_tags" do
  recipe "glusterfs::server_handle_tag_updates"
  recipients_tags "#{TAG_SPARE}=true"
end
  
rightscale_marker :end
