rightscale_marker :begin

TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
BRICK_NUM = `#{list_tags} |grep '#{TAG_BRICK_NUM}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{node[:cloud][:private_ips][0]}:#{EXPORT_DIR}"


# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"
peer_ip = node[:glusterfs][:server][:peer]
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
ruby_block "Migrating brick #{BRICK_NUM} from #{peer_ip} to #{local_ip}" do
  block do
    system "gluster volume replace-brick #{VOL_NAME} #{local_ip}:#{EXPORT_DIR} #{peer_ip}:#{EXPORT_DIR} start &> #{CMD_LOG}"
    log "Replaced #{peer_ip} in cluster.  Use status to check migration"
#    GlusterFS::Error.check(CMD_LOG, "")
  end
end


rightscale_marker :end
