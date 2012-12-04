#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2012, RightScale Inc. 
#
# All rights reserved - Do Not Redistribute
#
rightscale_marker :begin
log "installing the sphinx package"
case node[:platform]
when "redhat","centos","scientific"
  yum_package "mysql50" do
    action :install
  end

  yum_package "#{node[:sphinx][:package]}" do
    action :install
  end
when "ubuntu","debian"
  package "#{node[:sphinx][:package]}" do
    action :install
  end
end

log "Creating Sphinx Config File"
template "#{node[:sphinx][:conf_file]}" do
  source "sphinx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:index_storage_location => "/mnt/#{node[:sphinx][:storage_type]}/sphinx")
  action :create
end

log "create storage directory"
directory "/mnt/#{node[:sphinx][:storage_type]}/sphinx" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

log "create log directory"
directory "/var/log/sphinx" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

log "Opening firewall port:#{node[:sphinx][:port]}"
include_recipe "sys_firewall::default"
sys_firewall "#{node[:sphinx][:port]}"

log "creating profile"
gen_profile_script "default" do
  cookbook_name "sphinx"
  enable true
end

rightscale_marker :end
