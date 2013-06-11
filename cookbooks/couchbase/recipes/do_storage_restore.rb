rs_utils_marker :begin

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
lineage = node[:couchbase][:backup_lineage]
lineage_override = node[:couchbase][:backup_lineage_override]
restore_lineage = lineage_override == nil || lineage_override.empty? ? lineage : lineage_override
log " Input lineage #{lineage}"
log " Input lineage_override #{lineage_override}"
log " Using lineage #{restore_lineage}"
#
block_device NICKNAME do
  lineage restore_lineage
  timestamp_override node[:block_device][:devices][:device1][:backup][:timestamp_override]
  volume_size get_device_or_default(node, :device1, :volume_size)
  action :primary_restore
end

node[:couchbase][:storage_type] = node[:block_device][:devices][:device1][:mount_point].split('/').last
include_recipe 'couchbase::default'

directory "/mnt/ephemeral/couchbase" do
  action :delete
  recursive true
  only_if "test -e /mnt/ephemeral/couchbase"
end

rs_utils_marker :end
