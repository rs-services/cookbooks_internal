#
# Cookbook Name:: rightscale_services_tools
# Recipe:: stop-nat-monitor
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

rightscale_tools_services "stop nat monitor" do
  action :stop_nat_monitor
end

rightscale_marker :end