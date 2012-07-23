#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2012, RightScale Inc.
#
# All rights reserved - Do Not Redistribute
#
class Chef::Recipe
  include RightScale::Hadoop::Helper
end

rightscale_marker :begin

set_node_type_tag(node[:hadoop][:node][:type])


include_recipe 'hadoop::install'
include_recipe 'hadoop::do_config'
include_recipe 'hadoop::do_init'

rightscale_marker :end