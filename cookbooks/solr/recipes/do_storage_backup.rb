class Chef::Recipe
  include RightScale::BlockDeviceHelper
end

class Chef::Resource::BlockDevice
  include RightScale::BlockDeviceHelper
end
include_recipe 'block_device::default'

DATA_DIR = node[:block_device][:devices][:device1][:mount_point]
NICKNAME = get_device_or_default(node, :device1, :nickname)
# TODO: this code is duplicated between db and block device. Need to do something
# # about that...... Getting it working first
lineage = node[:solr][:backup_lineage]
lineage_override = node[:solr][:backup_lineage_override]
restore_lineage = lineage_override == nil || lineage_override.empty? ? lineage : lineage_override
log " Input lineage #{lineage}"
log " Input lineage_override #{lineage_override}"
log " Using lineage #{restore_lineage}"
#

block_device NICKNAME do
  action :backup_lock_take
  force false
end

log " Performing Primary backup Snapshot with lineage #{restore_lineage}.."
# Requires block_device node[:db][:block_device] to be instantiated
# previously. Make sure block_device::default recipe has been run.
block_device NICKNAME do
   action :snapshot
end

log " Performing Primary Backup of lineage #{restore_lineage} and post-backup cleanup..."
block_device NICKNAME do
# Backup/Restore arguments
  lineage restore_lineage
  max_snapshots get_device_or_default(node, :device1, :backup, :primary, :keep, :max_snapshots)
  keep_daily get_device_or_default(node, :device1, :backup, :primary, :keep, :keep_daily)
  keep_weekly get_device_or_default(node, :device1, :backup, :primary, :keep, :keep_weekly)
  keep_monthly get_device_or_default(node, :device1, :backup, :primary, :keep, :keep_monthly)
  keep_yearly get_device_or_default(node, :device1, :backup, :primary, :keep, :keep_yearly)
  # Secondary arguments
  secondary_cloud get_device_or_default(node, :device1, :backup, :secondary, :cloud)
  secondary_endpoint get_device_or_default(node, :device1, :backup, :secondary, :endpoint)
  secondary_container get_device_or_default(node, :device1, :backup, :secondary, :container)
  secondary_user get_device_or_default(node, :device1, :backup, :secondary, :cred, :user)
  secondary_secret get_device_or_default(node, :device1, :backup, :secondary, :cred, :secret)
  action :primary_backup
end

block_device NICKNAME do
  action :backup_lock_give
end
