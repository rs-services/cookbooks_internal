#
# Cookbook Name:: rightscale_services_tools
# Recipe:: default
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

template "/etc/iptables.snat" do
  source "iptables.snat.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :cidr => node[:vpc_nat][:vpc_ipv4_cidr_block] )
  action :create
end

sysctl "net.ipv4.ip_forward" do
  value "1"
  action :set
end
 
sysctl "net.ipv4.conf.eth0.send_redirects" do
  value "0"
  action :set
end



rightscale_marker :end