rightscale_marker :begin

TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
TAG_BRICK_NUM = node[:glusterfs][:tag][:bricknum]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
#BRICK_NUM = `#{list_tags} |grep '#{TAG_BRICK_NUM}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{node[:cloud][:private_ips][0]}:#{EXPORT_DIR}"


BRICK_NUM = node[:glusterfs][:server][:replace_brick]

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"
peer_ip = node[:glusterfs][:server][:peer]
forced = node[:glusterfs][:server][:replace_brick_forced]
spare_uuid_tag = "server:uuid=#{node[:rightscale][:instance_uuid]}"
local_ip = node[:cloud][:private_ips][0]


#log "===> Going to probe #{peer_ip}"
#ruby_block "gluster peer probe #{peer_ip}" do
#  block do
#    # TODO netcat the port
#    system "gluster peer probe #{peer_ip} &> #{CMD_LOG}"
#    GlusterFS::Error.check(CMD_LOG, "Adding #{peer_ip} to cluster")
# end
#end

log "===> Going to live migrate brick #{BRICK_NUM}"
log "DEBUG: gluster volume replace-brick #{VOL_NAME} #{local_ip}:#{EXPORT_DIR} #{peer_ip}:#{EXPORT_DIR} start"
log "DEBUG: gluster volume replace-brick #{VOL_NAME} #{local_ip}:#{EXPORT_DIR} #{peer_ip}:#{EXPORT_DIR} commit"

ruby_block "Migrating brick #{BRICK_NUM} from #{local_ip} to #{peer_ip}" do
  block do
    system "gluster volume replace-brick #{VOL_NAME} #{peer_ip}:#{EXPORT_DIR} #{local_ip}:#{EXPORT_DIR} start &> #{CMD_LOG}"
    sleep 10
if forced == "Yes"
    system "gluster volume replace-brick #{VOL_NAME} #{peer_ip}:#{EXPORT_DIR} #{local_ip}:#{EXPORT_DIR} commit force &> #{CMD_LOG}"
else
    system "gluster volume replace-brick #{VOL_NAME} #{peer_ip}:#{EXPORT_DIR} #{local_ip}:#{EXPORT_DIR} commit &> #{CMD_LOG}"
end
    sleep 2
    system "gluster peer detach #{peer_ip}"

#    GlusterFS::Error.check(CMD_LOG, "failed") # No need to check log.. fire and forget
  end
end
    GlusterFS::Error.check(CMD_LOG, "failed")
    log "Replaced #{peer_ip} in cluster.  Use status to check migration"
    log "# gluster volume replace-brick #{VOL_NAME} #{peer_ip}:#{EXPORT_DIR} #{local_ip}:#{EXPORT_DIR} status"

sleep 5

#Update my tags now that I'm in a replica set

 # Remove TAG_SPARE from hosts and add TAG_ATTACH
 #
 # (the remote recipe being invoked is intelligent and only removes the tag if
 # its brick is in fact part of the volume, thus safe to run on all hosts.)
 
  log "===> Running remote recipe to update tags"
  remote_recipe "update_tags" do
    recipe "glusterfs::server_handle_tag_updates"
    recipients_tags  spare_uuid_tag
  end

rightscale_marker :end
