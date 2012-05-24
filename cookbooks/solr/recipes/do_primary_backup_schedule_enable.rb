rs_utils_marker :begin

class Chef::Recipe
  include RightScale::BlockDeviceHelper
end

NICKNAME = get_device_or_default(node, :device1, :nickname)

block_device NICKNAME do
  lineage node[:solr][:backup_lineage]
  cron_backup_recipe "solr::do_storage_backup"
  cron_backup_minute rand(60)
  persist false
  action :backup_schedule_enable
end

rs_utils_marker :end
