marker "recipe_start"
# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.server_create_cluster.out.#{$$}"

# Constants as shortcuts for attributes
#
BLOCK_DEVICE_MNT=node[:block_device][:devices][:device1][:mount_point]
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
AUTH_ALLOW = node[:glusterfs][:server][:volume_auth]
IP_ADDR    = node[:cloud][:private_ips][0]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp

Chef::Log.info "VOLUME INFORMATION:"
Chef::Log.info "~~~~~~~~~~~~~~~~~~~"
Chef::Log.info "Volume Name: #{VOL_NAME}"
Chef::Log.info "Volume Type: #{VOL_TYPE}"
Chef::Log.info "Replica Count: #{REPL_COUNT} " +
               "(only used for Replicated volumes)"
log "Mount point: #{BLOCK_DEVICE_MNT}"

require 'mixlib/shellout'
log "doing attribute set"
attr1=Mixlib::ShellOut.new("setfattr -x trusted.glusterfs.volume-id #{EXPORT_DIR}").run_command
log "setfattr -x trusted.glusterfs.volume-id #{EXPORT_DIR} STDOUT: #{attr1.stdout} STDERR: #{attr1.stderr}"
attr2=Mixlib::ShellOut.new("setfattr -x trusted.gfid #{EXPORT_DIR}").run_command
log "setfattr -x trusted.gfid STDOUT: #{attr2.stdout} STDERR: #{attr2.stderr}"
attr3=Mixlib::ShellOut.new("rm -fr #{EXPORT_DIR}/.glusterfs").run_command
log "rm -fr #{EXPORT_DIR}/.glusterfs STDOUT: #{attr3.stdout} STDERR: #{attr3.stderr}"

