#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2012, RightScale Inc
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

# Create Cassandra user
user "cassandra" do
	comment "Cassandra software owner"
end

# Download Cassandra
remote_file "/tmp/cassandra.tar.gz" do
	source "http://stefhen-rightscale.s3.amazonaws.com/apache-cassandra-#{node['cassandra']['version']}-bin.tar.gz"
	checksum "08313fbfd5cc7d91a637a2a27c5c6bb4d3bf6ce8ff5eae9a14c20474faa8cf12"
end

# Untar and install
bash "untar_cassandra" do
	cwd "/tmp"
	code <<-EOM
		tar zxf cassandra.tar.gz -C /usr/local
		ln -s /usr/local/apache-cassandra-#{node['cassandra']['version']} /usr/local/cassandra
		chown -R cassandra: /usr/local/apache-cassandra-#{node['cassandra']['version']}
	EOM
end

# Create cassandra commit, saved_caches dirs and logging dir
[ node['cassandra']['commitlog_directory'], node['cassandra']['saved_caches_directory'], node['cassandra']['log4j_directory'] ].each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    action :create
    recursive true
  end
end

# Create cassandra data dir(s)
node['cassandra']['data_file_directories'].each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    action :create
    recursive true
  end
end

# Install log4j-server.properties
template "/usr/local/apache-cassandra-#{node['cassandra']['version']}/conf/log4j-server.properties" do
	source "log4j-server.properties.erb"
	owner "cassandra"
	group "cassandra"
	mode "0644"
	variables({
		:log4j_directory => node['cassandra']['log4j_directory']
	})
end 

cookbook_file "/etc/init.d/cassandra" do
	source "cassandra"
	mode "0755"
	backup false
end

rightscale_marker :end
