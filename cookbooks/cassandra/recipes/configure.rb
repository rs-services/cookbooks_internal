#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2012, RightScale Inc
#
# All rights reserved - Do Not Redistribute 
#

rightscale_marker :begin

template "/usr/local/cassandra/conf/cassandra.yaml" do
  source "cassandra.yaml.erb"
  mode "0644"
  owner "cassandra"
  group "cassandra"
  variables({
    :version                => node['cassandra']['version'],
    :cluster_name           => node['cassandra']['cluster_name'],
    :seeds                  => node['cassandra']['seeds'],
    :num_tokens             => node['cassandra']['num_tokens'],
    :data_file_directories  => node['cassandra']['data_file_directories'],
    :commitlog_directory    => node['cassandra']['commitlog_directory'],
    :saved_caches_directory => node['cassandra']['saved_caches_directory']
	})
  notifies :start, "service[cassandra]", :immediately
end

service "cassandra" do
	action :nothing
end

rightscale_marker :end
