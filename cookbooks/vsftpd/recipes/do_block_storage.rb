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

do_for_block_devices node[:block_device] do |device|
  log " Enabling continuous backups for device #{device} via cron job:#{get_device_or_default(node, device, :backup, :primary, :cron, :minute)} #{get_device_or_default(node, device, :backup, :primary, :cron, :hour)}"

  block_device_json = "/var/lib/rightscale_block_device_#{device}.json"

  file block_device_json do
    owner 'root'
    group 'root'
    mode 0644
    content JSON.dump({:block_device => {:devices_to_use => device}})
    backup false
  end

  cron_minute = get_device_or_default(node, device, :backup, :primary, :cron, :minute).to_s
  cron_hour = get_device_or_default(node, device, :backup, :primary, :cron, :hour).to_s

  cron "RightScale continuous primary backups for device #{device}" do
    minute cron_minute unless cron_minute.empty?
    hour cron_hour unless cron_hour.empty?
    user "root"
    command "rs_run_recipe -j '#{block_device_json}' -n 'block_device::do_primary_backup' 2>&1 > /var/log/rightscale_tools_cron_backup_block_device_#{device}.log"
    action :create
  end
end

rightscale_marker :end



