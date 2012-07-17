rs_utils_marker :begin

class Chef::Recipe
  include RightScale::BlockDeviceHelper
end

NICKNAME = get_device_or_default(node, :device1, :nickname)

recipe="couchbase::do_storage_backup"
minute=rand(60).to_s()
cron "RightScale remote_recipe #{recipe}" do
  minute "#{minute}" unless minute.empty?
  user "root"
  command "rs_run_recipe -n \"#{recipe}\" 2>&1 > /var/log/rightscale_tools_cron_backup.log"
  action :create
end

rs_utils_marker :end
