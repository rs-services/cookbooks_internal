rightscale_marker :begin
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

class Chef::Recipe
  include RightScale::BlockDeviceHelper
end

class Chef::Resource::BlockDevice
  include RightScale::BlockDeviceHelper
end

# In this code block, we restore snapshot from a lineage specified by
# "lineage" attribute. We can override that lineage by specifying
# "device/lineage_override" input. If device/timestamp_override input is set,
# the snapshot from that timestamp in the lineage will be restored. Else
# the snapshot with the most recent timestamp will be restored.
# See cookbooks/block_device/providers/default.rb for definition of
# primary_restore action and cookbooks/block_device/libraries/block_device.rb
# for definition of "do_for_block_devices", "set_restore_params" and "get_device_or_default" methods.
#
do_for_block_devices node[:block_device] do |device|

  # Do the restore.
  log "  Creating block device and restoring data from primary backup for device #{device}..."
  restore_lineage, restore_timestamp_override = set_restore_params(
    get_device_or_default(node, device, :backup, :lineage),
    get_device_or_default(node, device, :backup, :lineage_override),
    get_device_or_default(node, device, :backup, :timestamp_override)
  )
  ruby_block "set_attr" do
    block do 
      require 'mixlib/shellout'
      while !File.exists?(BLOCK_DEVICE_MNT)
        Chef::Log.info "waiting on block device available"
        sleep 5
      end
      Chef::Log.info "doing attribute set"
      attr1=Mixlib::ShellOut.new("setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT}").run_command
      Chef::Log.info "setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT} STDOUT: #{attr1.stdout} STDERR: #{attr1.stderr}"
      attr2=Mixlib::ShellOut.new("setfattr -x trusted.gfid #{BLOCK_DEVICE_MNT}").run_command
      Chef::Log.info "setfattr -x trusted.gfid STDOUT: #{attr2.stdout} STDERR: #{attr2.stderr}"
      attr3=Mixlib::ShellOut.new("rm -fr #{EXPORT_DIR}/.glusterfs").run_command
      Chef::Log.info "rm -fr #{EXPORT_DIR}/.glusterfs STDOUT: #{attr3.stdout} STDERR: #{attr3.stderr}"
    end
    action :nothing
  end

  block_device get_device_or_default(node, device, :nickname) do
    # Backup/Restore arguments
    lineage restore_lineage
    timestamp_override restore_timestamp_override
    action :primary_restore
  end
  ruby_block "set_attr" do
    block do
      require 'mixlib/shellout'
      while !File.exists?(BLOCK_DEVICE_MNT)
        Chef::Log.info "waiting on block device available"
        sleep 5
      end
      Chef::Log.info "doing attribute set"
      attr1=Mixlib::ShellOut.new("setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT}").run_command
      Chef::Log.info "setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT} STDOUT: #{attr1.stdout} STDERR: #{attr1.stderr}"
      attr2=Mixlib::ShellOut.new("setfattr -x trusted.gfid #{BLOCK_DEVICE_MNT}").run_command
      Chef::Log.info "setfattr -x trusted.gfid STDOUT: #{attr2.stdout} STDERR: #{attr2.stderr}"
      attr3=Mixlib::ShellOut.new("rm -fr #{EXPORT_DIR}/.glusterfs").run_command
      Chef::Log.info "rm -fr #{EXPORT_DIR}/.glusterfs STDOUT: #{attr3.stdout} STDERR: #{attr3.stderr}"
    end
    action :create
  end
end

require 'mixlib/shellout'
log "doing attribute set"
attr1=Mixlib::ShellOut.new("setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT}").run_command
log "setfattr -x trusted.glusterfs.volume-id #{BLOCK_DEVICE_MNT} STDOUT: #{attr1.stdout} STDERR: #{attr1.stderr}"
attr2=Mixlib::ShellOut.new("setfattr -x trusted.gfid #{BLOCK_DEVICE_MNT}").run_command
log "setfattr -x trusted.gfid STDOUT: #{attr2.stdout} STDERR: #{attr2.stderr}"
attr3=Mixlib::ShellOut.new("rm -fr #{EXPORT_DIR}/.glusterfs").run_command
log "rm -fr #{EXPORT_DIR}/.glusterfs STDOUT: #{attr3.stdout} STDERR: #{attr3.stderr}"

rightscale_marker :end
