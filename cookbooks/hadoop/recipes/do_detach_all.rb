#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

class Chef::Recipe
  include RightScale::Hadoop::Helper
end

hosts = Array.new 

rightscale_server_collection "slaves" do
  tags ["hadoop:node_type=datanode"]
  empty_ok false
  action :load
end
#r.run_action(:load)
        
log "SLAVES: #{node[:server_collection]['slaves'].inspect}"
node[:server_collection]['slaves'].to_hash.values.each do |tags|
  ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
  hosts.push(ip)
end

remove_hosts "Remove all datanodes" do
  hosts  hosts
  file 'slaves'
  restart  false
  #only remove slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end



rightscale_marker :end

