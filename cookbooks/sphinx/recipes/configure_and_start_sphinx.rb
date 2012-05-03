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
  template "/etc/sphinx/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    #variables()
  end
when "debian","ubuntu"
  template "/etc/sphinxsearch/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    #variables()
  end
end

execute "#{node[:sphinx][:indexer]}" do
  command "#{node[:sphinx][:indexer]} --all"
  action :run
end

service "#{node[:sphinx][:service]}" do
  action :start
end
