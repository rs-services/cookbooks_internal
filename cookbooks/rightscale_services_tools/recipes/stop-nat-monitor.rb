#
# Cookbook Name:: rightscale_services_tools
# Recipe:: stop-nat-monitor
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

bash "stop nat-monitor.sh" do
  user "root"
  cwd "/root"
  code <<-EOH
  pkill nat-monitor > /dev/null
  EOH
end

rightscale_marker :end