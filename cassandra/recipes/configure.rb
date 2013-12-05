#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

dirs = Array.new
dirs.push(node[:cassandra][:commitlog_directory])
dirs.push(node[:cassandra][:saved_caches_directory])
dirs += node[:cassandra][:data_file_directories]

seed_ips = Array.new

seed_hosts = rightscale_server_collection "seed_hosts" do
  tags ["cassandra:seed_host=true"]
  mandatory_tags ["server:private_ip_0"]
  empty_ok false
  action :nothing
end
seed_hosts.run_action(:load)

if node["server_collection"]["seed_hosts"]
  Chef::Log.info "Server collection found ..."
  node["server_collection"]["seed_hosts"].to_hash.values.each do |tag|
    seed_ips.push(RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tag))
  end
end

dirs.each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
  end
end

template "/etc/cassandra/conf/cassandra.yaml" do
  source "cassandra.yaml.erb"
  owner "cassandra"
  group "cassandra"
  mode "0644"
  variables({
    :cluster_name           => node[:cassandra][:cluster_name],
    :commitlog_directory    => node[:cassandra][:commitlog_directory],
    :data_file_directories  => node[:cassandra][:data_file_directories],
    :saved_caches_directory => node[:cassandra][:saved_caches_directory],
    :seeds                  => seed_ips
  })
end

service "cassandra" do
  action [:enable, :start]
end

rightscale_marker :end
