# Cookbook Name:: couchbase
# Recipe:: setup_or_restore
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#

rs_utils_marker :begin

  initial_setup = node[:couchbase][:initial_setup]

log "Couchbase initial setup set to #{initial_setup}"

case initial_setup
  when "TRUE"
    include_recipe "block_device::setup_block_device"
  else
    include_recipe "block_device::do_primary_restore"
end


rs_utils_marker :end
