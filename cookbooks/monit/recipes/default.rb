#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "#{node[:monit][:package]}" do
  action :install
end
directory "/etc/monit/conf.d" do
  action :create
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

template "/etc/monit/monitrc" do
  source "monitrc.erb"
  owner "root"
  group "root"
  mode "0755"
  action :create
end

service "monit" do
  action [ :enable, :start ]
end
