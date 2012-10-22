#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
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
rs_utils_marker :begin

if node[:redis][:install_from] == "package"
  include_recipe "redis::package"
else
  include_recipe "redis::source"
end

user node[:redis][:user] do
end

directory node[:redis][:data_dir] do
  owner node[:redis][:user]
  mode "0750"
  recursive true
end

log "#{node[:redis][:conf_dir]}"
directory node[:redis][:conf_dir]

directory "#{node[:redis][:conf_dir]}/conf.d" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

directory node[:redis][:pid_dir] do
  owner node[:redis][:user]
  mode "0750"
  recursive true
end

directory node[:redis][:log_dir] do
  owner node[:redis][:user]
  mode "0750"
end

file "/etc/redis.conf" do
  backup false
  action :delete
  only_if "test -e /etc/redis.conf"
end

template "#{node[:redis][:conf_file]}" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  #variables()
  action :create
end

case node[:platform]
when "centos","redhat","scientific"
  template "/etc/init.d/redis" do
    source "redis.init.centos"
    owner "root"
    group "root"
    mode "0755"
  end
when "debian","ubuntu"
  template "/etc/init.d/redis-server" do
    source "redis.init.ubuntu"
    owner "root"
    group "root"
    mode "0755"
  end
end

right_link_tag "redis:role=#{node['redis']['replication']['master_role']}" do
  action :publish
end

service "#{node[:redis][:service_name]}" do
  action [:enable,:start]
end

remote_file "/tmp/redis-2.1.1.gem" do
  source "http://rubygems.org/downloads/redis-2.1.1.gem"
  owner "root" 
  group "root"
  mode "0644"
end

gem_package "redis" do
  action :install
  gem_binary "/usr/bin/gem"
  version "2.1.1"
end

Gem.clear_paths

rs_utils_marker :end
