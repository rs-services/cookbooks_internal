#
# Cookbook Name:: app
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin


# Adding iptables rule to allow hadoop servers connections
log "Setting up namenode firewall ports for #{node[:hadoop][:namenode][:address][:port]}"
sys_firewall "Open  hadoop port" do
  machine_tag "hadoop:node_type=namenode"
  port node[:hadoop][:namenode][:address][:port].to_i
  enable true
  action :update
  only_if node[:hadoop][:node][:type]=='namenode'
end

log "Setting up namenode http firewall ports for #{node[:hadoop][:namenode][:http][:port]}"
sys_firewall "Open  hadoop port" do
  machine_tag "hadoop:node_type=namenode"
  port node[:hadoop][:namenode][:http][:port].to_i
  enable true
  action :update
  only_if node[:hadoop][:node][:type]=='namenode'
end

log "Setting up datanode address firewall ports for #{node[:hadoop][:datanode][:address][:port]}"
sys_firewall "Open hadoop port" do
  machine_tag "hadoop:node_type=datanode"
  port node[:hadoop][:datanode][:address][:port].to_i
  enable true
  action :update
  only_if node[:hadoop][:node][:type]=='datanode'
end

log "Setting up datanode  ipc firewall ports for #{node[:hadoop][:datanode][:ipc][:port]}"
sys_firewall "Open hadoop port" do
  machine_tag "hadoop:node_type=datanode"
  port node[:hadoop][:datanode][:ipc][:port].to_i
  enable true
  action :update
  only_if node[:hadoop][:node][:type]=='datanode'
end
  
log "Setting up datanode  http firewall ports for #{node[:hadoop][:datanode][:http][:port]}"
sys_firewall "Open hadoop port" do
  #machine_tag "hadoop:node_type=datanode"
  port node[:hadoop][:datanode][:http][:port].to_i
  enable true
  action :update
  only_if node[:hadoop][:node][:type]=='datanode'
end
rs_utils_marker :end
