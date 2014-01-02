#
# Cookbook Name:: 389-DS
# Recipe:: default
#
# Copyright 2013, RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
rightscale_marker :begin

sys_dns "default" do
  id node[:DS389][:dns_id]
  address node[:cloud][:public_ips][0]
  action :set_private
end

sleep 61

include_recipe "DS389::#{node[:DS389][:install_type]}"

%w{389 636 9830}.each { |port|
  sys_firewall port do
    action :update
  end
}

suffix_str=""
node[:DS389][:AdminDomain].split('.').each_with_index do |domain,i| 
  suffix_str+="dc=#{domain}"
  suffix_str+="," unless i == (node[:DS389][:AdminDomain].split('.').length - 1)
end
template "/tmp/setup.inf" do
  owner "root"
  group "root"
  mode "0644"
  variables(:hostname => node[:DS389][:Hostname],
            :admin_domain => node[:DS389][:AdminDomain],
            :admin_id => node[:DS389][:ConfigDirectoryAdminID],
            :admin_pass => node[:DS389][:ConfigDirectoryAdminPwd],
            :suffix => suffix_str,
            :dn_pass => node[:DS389][:RootDNPwd])
  action :create
end

bash "tune" do 
  code <<-EOF
echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
echo "fs.file-max = 64000" >> /etc/sysctl.conf
echo "* soft nofile 8192" >> /etc/security/limits.conf   
echo "* hard nofile 8192" >> /etc/security/limits.conf
echo "ulimit -n 8192" >> /etc/profile
sysctl -w
EOF
end

execute "/usr/sbin/setup-ds-admin.pl -s -f /tmp/setup.inf"

execute "/usr/sbin/setup-ds-dsgw"

service "dirsrv-admin" do
  action :restart
end

rightscale_marker :end
