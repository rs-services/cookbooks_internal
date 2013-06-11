rs_utils_marker :begin

class Chef::Recipe
  include RightScale::BlockDeviceHelper
end

NICKNAME = get_device_or_default(node, :device1, :nickname)

block_device NICKNAME do
  cron_backup_recipe "couchbase::do_storage_backup"
  action :backup_schedule_disable
end

rs_utils_marker :end
