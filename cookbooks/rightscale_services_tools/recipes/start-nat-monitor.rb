#
# Cookbook Name:: rightscale_services_tools
# Recipe:: start-nat-monitor
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

rightscale_tools_services "start monitor" do
  action :start_nat_monitor
  only_if {node[:vpc_nat][:nat_ha]=='enabled'}
end

rightscale_marker :end