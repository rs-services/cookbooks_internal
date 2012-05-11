#
# Cookbook Name:: monit
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node[:platform]
when "centos","redhat","scientific"
  case node[:platform_version].to_i
  when 5
    cookbook_file "/tmp/monit-5.1.1-2.x86_64.rpm" do
      source "monit-5.1.1-2.x86_64.rpm"
      cookbook 'monit'
      owner "root"
      group "root"
      mode "0644"
      action :create_if_missing
    end
    
    package "monit" do
      action :install
      source "/tmp/monit-5.1.1-2.x86_64.rpm"
      provider Chef::Provider::Package::Rpm
      not_if "test -e /usr/bin/monit"
    end
  when 6
    package "#{node[:monit][:package]}" do
      action :install
      not_if "test -e /usr/bin/monit"
    end
  end
when "ubuntu","debian"
  package "#{node[:monit][:package]}" do
    action :install
  end
end

directory "#{node[:monit][:conf_ext_dir]}" do
  action :create
  owner "root"
  group "root"
  mode "0755"
  recursive true
end

template "#{node[:monit][:conf_file]}" do
  source "monitrc.erb"
  owner "root"
  group "root"
  mode "0700"
  action :create
end

template "/etc/default/monit" do
  source "monit_default.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

service "monit" do
  pattern ""
  action [ :enable, :start ]
end
