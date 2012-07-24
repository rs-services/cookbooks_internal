#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin



        
rightscale_server_collection "namenodes" do
  tags ["hadoop:node_type=namenode"]
  action :load
end

rightscale_server_collection "datanodes" do
  tags ["hadoop:node_type=datanode"]
  action :load
end  

ruby_block "attach" do
  block do
    

    node[:server_collection]['namenodes'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      node[:namenodes].push(ip)
    end
    node[:server_collection]['datanodes'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      node[:datanodes].push(ip)
    end

    # add nodenames as masters
    node[:namenodes].each do |m|
      node[:datanodes].push(m)
    end
  end
end

create_hosts "Add all datanodes" do
  hosts  node[:datanodes]
  file 'slaves'
  restart  false
  #only add slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end

#if node[:hadoop][:node][:type]=='datanode'
  create_hosts "Add all namenodes" do
    hosts  node[:namenodes]
    file 'masters'
    restart  true
 
  end
#end


rightscale_marker :end

