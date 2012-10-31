#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2012, RightScale Inc
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

case node['platform']
when "ubuntu"
  include_recipe "apt"

  apt_repository "cassandra-repo" do
    uri "http://www.apache.org/dist/cassandra/debian"
    components ["11x", "main"]
    keyserver "pgp.mit.edu"
    key "4BD736A82B5C1B00"
    action :add
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end

  apt_preference "cassandra" do
    pin "version #{node['cassandra']['version']}"
    pin_priority "1000"
  end
end

package "cassandra" 

# Create cassandra commit and saved_caches dirs
[node['cassandra']['commitlog_directory'], node['cassandra']['saved_caches_directory']].each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "755"
    action :create
    recursive true
  end
end

# Create cassandra data dir(s)
node['cassandra']['data_file_directories'].each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "755"
    action :create
    recursive true
  end
end

template "/etc/cassandra/log4j-server.properties" do
  source "log4j-server.properties.erb"
  mode "0644"
  variables({
    :log4j_directory => node['cassandra']['log4j_directory']
  })
end

# This alters the default config file to use java-6-sun.
# Comment out to use OpenJDK.
template "/etc/init.d/cassandra" do
  source "cassandra"
  mode "0755"
end

rightscale_marker :end
