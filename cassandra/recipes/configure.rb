#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

seed_hosts = rightscale_server_collection "seed_hosts" do
  tags ["cassandra:seed_host=true"]
  mandatory_tags ["server:private_ip_0"]
  empty_ok false
  action :nothing
end
seed_hosts.run_action(:load)

seed_ips = Array.new

if node["server_collection"]["seed_hosts"]
  Chef::Log.info "Server collection found ..."
  node["server_collection"]["seed_hosts"].to_hash.values.each do |tag|
    seed_ips.push(RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tag))
  end
end

template "/etc/cassandra/conf/cassandra.yaml" do
  source "cassandra.yaml.erb"
  owner "cassandra"
  group "cassandra"
  mode "0644"
  variables({
    :cluster_name => node[:cassandra][:cluster_name],
    :seeds        => seed_ips
  })
end

service "cassandra" do
  action [:enable, :start]
end

rightscale_marker :end
