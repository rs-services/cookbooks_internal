#
# Cookbook Name:: vpc-nat
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

#bash "ip forwarding" do
#  
#
#  code <<-EOH
#  echo 1 >  /proc/sys/net/ipv4/ip_forward && \
#  echo 0 >  /proc/sys/net/ipv4/conf/eth0/send_redirects && \
#  /sbin/iptables -t nat -A POSTROUTING -o eth0 -s #{node[:vpc_nat][:vpc_ipv4_cidr_block]} -j MASQUERADE
#  if [ $? -ne 0 ] ; then
#   echo "Configuration of PAT failed"
#   exit 0
#  fi
  #EOH
#end

rightscale_marker :end