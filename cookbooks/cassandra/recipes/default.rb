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

include_recipe "cassandra::setup_repos"

# RS - Going to use Samsung JDK cookbook

include_recipe "cassandra::required_packages"
include_recipe "cassandra::optional_packages"
include_recipe "cassandra::additional_settings"
include_recipe "cassandra::install"

log "enabling cassandra service"
service "cassandra" do
    action [ :enable, :start]
    supports :status => true, :restart => true, :reload => true  
end


if node[:sys_firewall][:enabled] == "enabled"
  log "Opening Cassandra Storage firewall port:#{node[:Cassandra][:storage_port]}"
  sys_firewall "#{node[:Cassandra][:storage_port]}"

  log "Opening Cassandra RPC firewall port:#{node[:Cassandra][:rpc_port]}"
  sys_firewall "#{node[:Cassandra][:rpc_port]}"
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
