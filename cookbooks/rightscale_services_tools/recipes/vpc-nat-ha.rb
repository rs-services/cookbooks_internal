#
# Cookbook Name:: vpc-nat
# Recipe:: default
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

template "/root/nat-monitor.sh" do
  source "nat-monitor.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :other_instance_id=> node[:vpc_nat][:other_instance_id],
  :other_route_id=>node[:vpc_nat][:other_route_id],
  :route_id=>node[:vpc_nat][:route_id],
  :ec2_url => node[:vpc_nat][:ec2_url]
  )
  action :create
end

rightscale_marker :end