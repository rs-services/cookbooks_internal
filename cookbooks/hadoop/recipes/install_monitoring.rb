#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

log "Installing collectd plugin to "
template "/etc/collectd.d/hadoop.conf" do
  source "collectd.erb"
  mode "0644"
end

template "/etc/collectd.d/hadoop.conf" do
  source "collectd.erb"
  mode "0644"
end



service "collectd" do
  action :restart
end

rightscale_marker :end