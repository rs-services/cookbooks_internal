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
  address node[:cloud][:public_ips][0]
  action :set
end

include_recipe "DS389::#{node[:DS389][:install_type]}"

%w{389 636 9830}.each { |port|
  sys_firewall port do
    action :update
  end
}

template "/tmp/setup.inf" do
  owner "root"
  group "root"
  mode "0644"
  variables(:hostname => node[:DS389][:Hostname],
            :host_ip => node[:cloud][:private_ips][0])
  action :create
end

execute "/usr/sbin/setup-ds-admin.pl -s -f /tmp/setup.inf"

execute "/usr/sbin/setup-ds-dsgw"

service "dirsrv-admin" do
  action :restart
end
rightscale_marker :end
