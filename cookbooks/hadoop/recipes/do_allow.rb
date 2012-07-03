#
# Cookbook Name:: app
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

# Adding iptables rule to allow hadoop servers connections
#default port 8020
if node[:hadoop][:node][:type]=='namenode'
  log "Setting up namenode firewall ports for #{node[:hadoop][:namenode][:address][:port]}"
  sys_firewall node[:hadoop][:namenode][:address][:port].to_i do
    machine_tag "hadoop:node_type=datanode"
    enable true
    action :update
  end
end

# default port 50070
if node[:hadoop][:node][:type]=='namenode'
  log "Setting up namenode http firewall ports for #{node[:hadoop][:namenode][:http][:port]}"
  sys_firewall node[:hadoop][:namenode][:http][:port].to_i do
    enable true
    action :update
  end
  
end

 #default port 50010 (on all hosts)
  log "Setting up datanode address firewall ports for #{node[:hadoop][:datanode][:address][:port]}"
  sys_firewall node[:hadoop][:datanode][:address][:port].to_i do
    machine_tag "hadoop:node_type=*"
    enable true
    action :update
  end
  
# default port 50020
if node[:hadoop][:node][:type]=='datanode'
  log "Setting up datanode  ipc firewall ports for #{node[:hadoop][:datanode][:ipc][:port]}"
  sys_firewall node[:hadoop][:datanode][:ipc][:port].to_i do
    machine_tag "hadoop:node_type=namenode"
    enable true
    action :update
  end
end 

# default port 50075 
if node[:hadoop][:node][:type]=='datanode'
  log "Setting up datanode http firewall ports for #{node[:hadoop][:datanode][:http][:port]}"
  sys_firewall node[:hadoop][:datanode][:http][:port].to_i do
    port 
    enable true
    action :update
  end
end

rs_utils_marker :end
