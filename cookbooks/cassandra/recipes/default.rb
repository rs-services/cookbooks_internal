#
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Public Variable Declarations
# 
###################################################

# Stop Cassandra if it is running.
# Different for Debian due to service package.
#if node[:platform] == "debian"
#  service "cassandra" do
#    action :stop
#    ignore_failure true
#  end
#else
#  service "cassandra" do
#    action :stop
#  end
#end

# Only for debug purposes
OPTIONAL_INSTALL = false 

include_recipe "cassandra::setup_repos"


# RS - Going to use Samsung JDK cookbook

include_recipe "cassandra::required_packages"

if OPTIONAL_INSTALL
  include_recipe "cassandra::optional_packages"
end

include_recipe "cassandra::additional_settings"
include_recipe "cassandra::install"

#include_recipe "cassandra::token_generation"
#include_recipe "cassandra::write_configs"
#include_recipe "cassandra::restart_service"
#
#start service if not running

service "cassandra" do
    action :enable
    supports :status => true, :restart => true, :reload => true
    #action :start
end

right_link_tag "cassandra:cluster_name=#{node[:Cassandra][:cluster_name]}" do
  action :publish
end

right_link_tag "cassandra:rpc_address=#{node[:cassandra][:rpc_address]}" do
  action :publish
end

right_link_tag "cassandra:initial_token=#{node[:cassandra][:initial_token]}" do
  action :publish
end
