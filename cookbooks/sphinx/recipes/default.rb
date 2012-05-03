#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2012, RightScale Inc. 
#
# All rights reserved - Do Not Redistribute
#
Log "installing the sphinx package"
case node[:platform]
when "redhat","centos","scientific"
  yum_package "mysql50" do
    action :install
  end

  yum_package "sphinx" do
    action :install
  end

  directory "/mnt/#{node[:sphinx][:storage_type]}/sphinx" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
  end

  template "/etc/sphinx/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(:index_storage_location => "/mnt/#{node[:sphinx][:storage_type]}/sphinx" )
  end
when "debian","ubuntu"
  package "sphinxsearch" do
    action :install
  end
  
  directory "/mnt/#{node[:sphinx][:storage_type]}/sphinx" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    recursive true
  end
  
  template "/etc/sphinxsearch/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(:index_storage_location => "/mnt/#{node[:sphinx][:storage_type]}/sphinx")
  end
end

include_recipe "sys_firewall::default"
sys_firewall "#{node[:sphinx][:port]}"
