#
# Cookbook Name:: rkhunter
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


rightscale_marker :begin

package "rkhunter" do
  action :install
end

template "/etc/rkhunter.conf" do
  source "rkhunter.conf.erb"
  owner "root"
  group "root"
  mode "0640"
  #variables()
  action :create
end

template "/etc/sysconfig/rkhunter" do
  source "sysconfig.erb"
  owner "root"
  group "root"
  mode "0640"
  variables( :admin_email => node[:rkhunter][:admin_email] )
  action :create
end

template "/etc/cron.daily/rkhunter" do
  source "cron.erb"
  owner "root"
  group "root"
  mode "0755"
  #variables()
  action :create
end

bash "rkhunter --update" do
  code <<-EOF
    rkhunter --update
  EOF
end

rightscale_marker :end

