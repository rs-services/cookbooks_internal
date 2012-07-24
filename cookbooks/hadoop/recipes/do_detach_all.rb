#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin



rightscale_server_collection "slaves" do
  tags ["hadoop:node_type=datanode"]
  empty_ok false
  action :load
end
    
ruby_block "get_slaves" do
  block do

    node[:server_collection]['slaves'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      node[:hosts].push(ip)
    end
  end
end

remove_hosts "Remove all datanodes" do
  hosts node[:hosts]
  file 'slaves'
  restart  false
  #only remove slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end



rightscale_marker :end

