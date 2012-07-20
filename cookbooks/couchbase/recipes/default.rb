#
# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

couchbase_edition = "enterprise"
couchbase_version = "1.8.1"
couchbase_package = "couchbase-server-#{couchbase_edition}_x86_64_#{couchbase_version}.rpm"

log "downloading #{couchbase_package}"

if not File.exists?("/tmp/#{couchbase_package}")
  remote_file "/tmp/#{couchbase_package}" do
    source "http://packages.couchbase.com/releases/#{couchbase_version}/#{couchbase_package}"
    mode "0644"
  end
end

log "installing #{couchbase_package}"

package "couchbase-server" do
  source "/tmp/#{couchbase_package}"
  provider Chef::Provider::Package::Rpm
  action :install
end

log "configuring #{couchbase_package}"

log("/opt/couchbase/bin/couchbase-cli cluster-init" +
    "        -c 127.0.0.1:8091" +
    "        --cluster-init-username=#{node[:db_couchbase][:cluster][:username]}")
execute "initializing cluster with username: #{node[:db_couchbase][:cluster][:username]}" do
  command("sleep 10" +
          " && /opt/couchbase/bin/couchbase-cli cluster-init" +
          "        -c 127.0.0.1:8091" +
          "        --cluster-init-username=#{node[:db_couchbase][:cluster][:username]}" +
          "        --cluster-init-password=#{node[:db_couchbase][:cluster][:password]}")
  action :run
end

unless (node[:block_device].nil? or
        node[:block_device][:devices].nil? or
        node[:block_device][:devices][:device1].nil? or
        node[:block_device][:devices][:device1][:mount_point].nil?)
  mount_point = node[:block_device][:devices][:device1][:mount_point]

  log "configuring to mount_point: #{mount_point}"

  execute "stopping server" do
    command "/etc/init.d/couchbase-server stop && sleep 5"
    action :run
  end

  execute "moving directory" do
    command "mv /opt/couchbase #{mount_point}"
    action :run
  end

  execute "symlinking directory" do
    command "ln -s #{mount_point}/couchbase /opt/"
    action :run
  end

  execute "starting server" do
    command "/etc/init.d/couchbase-server start && sleep 10"
    action :run
  end
end

log("/opt/couchbase/bin/couchbase-cli bucket-create" +
    "    -c 127.0.0.1:8091" +
    "    -u #{node[:db_couchbase][:cluster][:username]}" +
    "    --bucket=#{node[:db_couchbase][:bucket][:name]}" +
    "    --bucket-type=couchbase" +
    "    --bucket-ramsize=#{node[:db_couchbase][:bucket][:ram]}" +
    "    --bucket-replica=#{node[:db_couchbase][:bucket][:replica]}")
execute "creating bucket: #{node[:db_couchbase][:bucket][:name]}" do
  command("/opt/couchbase/bin/couchbase-cli bucket-create" +
          "    -c 127.0.0.1:8091" +
          "    -u #{node[:db_couchbase][:cluster][:username]}" +
          "    -p #{node[:db_couchbase][:cluster][:password]}" +
          "    --bucket=#{node[:db_couchbase][:bucket][:name]}" +
          "    --bucket-type=couchbase" +
          "    --bucket-password=\"#{node[:db_couchbase][:bucket][:password]}\"" +
          "    --bucket-ramsize=#{node[:db_couchbase][:bucket][:ram]}" +
          "    --bucket-replica=#{node[:db_couchbase][:bucket][:replica]}")
  action :run
end

cluster_tag = node[:db_couchbase][:cluster][:tag]
log("db_couchbase/cluster/tag: #{cluster_tag}")

if cluster_tag and !cluster_tag.empty?
  log("auto-joining nodes search...")
  node_public_ips = search(:node, "name:db_couchbase_cluster_tag:#{node[:db_couchbase][:cluster][:tag]}").map do |n|
    n[:cloud][:public_ips][0]
  end
  log("auto-joining nodes: #{node_public_ips}")
end

rightscale_marker :end
