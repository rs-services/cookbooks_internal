#
# Cookbook Name:: rightscale_services_tools
# Recipe:: start-nat-monitor
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

bash "start nat_monitor.sh" do
  user "root"
  cwd "/root"
  code <<-EOH
  pkill nat-monitor > /dev/null
  /root/nat-monitor.sh >> /var/log/nat-monitor.log 2>&1
  EOH
  only_if {node[:vpc_nat][:nat_ha]=='enabled'}
end

rightscale_marker :end