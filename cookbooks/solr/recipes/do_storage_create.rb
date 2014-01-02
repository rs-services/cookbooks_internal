rightscale_marker :begin

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
  lineage restore_lineage
  volume_size get_device_or_default(node, :device1, :volume_size)
  action :create
end

node[:solr][:storage_type] = node[:block_device][:devices][:device1][:mount_point].split('/').last
include_recipe 'solr::default'

directory "/mnt/ephemeral/solr" do
  action :delete
  recursive true
  only_if "test -e /mnt/ephemeral/solr"
end

rightscale_marker :end
