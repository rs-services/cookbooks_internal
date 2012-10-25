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

log "relocating #{couchbase_package}"

  execute "stopping server" do
    command "/etc/init.d/couchbase-server stop && sleep 15"
    action :run
  end

unless (node[:block_device].nil? or
        node[:block_device][:devices].nil? or
        node[:block_device][:devices][:device1].nil? or
        node[:block_device][:devices][:device1][:mount_point].nil?)
  mount_point = node[:block_device][:devices][:device1][:mount_point]

  log "configuring to mount_point: #{mount_point}"

  execute "moving directory" do
    command "mv /opt/couchbase #{mount_point}"
    action :run
  end

  execute "symlinking directory" do
    command "ln -s #{mount_point}/couchbase /opt/"
    action :run
  end
  
end
execute "starting server" do
  command "/etc/init.d/couchbase-server start && sleep 10"
    action :run
end

rightscale_marker :end
