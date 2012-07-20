# Cookbook Name:: couchbase
# Recipe:: setup_or_restore
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

  initial_launch = node[:couchbase][:initial_launch]

log "Couchbase initial setup set to #{initial_launch}"

case initial_launch
  when "TRUE"
    include_recipe "block_device::setup_block_device"
  else
    include_recipe "block_device::do_primary_restore"
end


rightscale_marker :end
