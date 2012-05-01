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
  yum_package "sphinx" do
    action :install
  end

  template "/etc/sphinx/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    #variables()
  end
when "debian","ubuntu"
  package "sphinxsearch" do
    action :install
  end

  template "/etc/sphinxsearch/sphinx.conf" do
    source "sphinx.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    #variables()
  end
end


