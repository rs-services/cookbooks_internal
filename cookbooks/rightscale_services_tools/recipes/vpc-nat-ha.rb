#
# Cookbook Name:: vpc-nat
# Cookbook Name:: rightscale_services_tools
#
# Copyright 2013, Rightscale Inc.
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin
# fail right way if java is not installed.
raise "JAVA doesn't seem to be installed!  JAVA_HOME is not set." if ENV["JAVA_HOME"] or ENV["JAVA_HOME"].blank?

if node[:vpc_nat][:nat_ha]=='enabled'
  
log "NAT HA enabled.  Proceding to install nat-monitor"  
  
template "/root/nat-monitor.sh" do
  source "nat-monitor.erb"
  owner  "root"
  group  "root"
  mode   "0700"
  variables( :other_instance_id=> node[:vpc_nat][:other_instance_id],
    :other_route_id=>node[:vpc_nat][:other_route_id],
    :route_id=>node[:vpc_nat][:route_id],
    :ec2_url => node[:vpc_nat][:ec2_url]
  )
  action :create
end
template "/root/credentials.txt" do
  source "credentials.erb"
  owner  "root"
  group  "root"
  mode   "0400"
  variables( :key=> node[:vpc_nat][:aws_account_id],
    :secret=>node[:vpc_nat][:aws_account_secret]
 
  )
  action :create
end

# not sure if this will every take affect
bash "install cron to run on reboot" do
  user "root"
  cwd "/root"
  code <<-EOH
  echo '@reboot /root/nat-monitor.sh > /var/log/nat-monitor.log 2>&1' | crontab
  EOH
end

bash "start nat-monitor.sh" do
  user "root"
  cwd "/root"
  code <<-EOH
  pkill nat-monitor > /dev/null
  /root/nat-monitor.sh >> /var/log/nat-monitor.log 2>&1
  EOH
end
# start the monitor
include_recipe "vpc_nat::start-nat-monitor"
else
  log "VPC HA is not enabled."
end

rightscale_marker :end