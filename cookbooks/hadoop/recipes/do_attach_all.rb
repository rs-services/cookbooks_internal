#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin


ruby_block "attach" do
  block do
    
    @slaves = Array.new
    @masters = Array.new
        
    rightscale_server_collection "masters" do
      tags ["hadoop:node_type=namenode"]
      empty_ok false
      action :load
    end

        

    node[:server_collection]['masters'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      @masters.push(ip)
    end

    rightscale_server_collection "slaves" do
      tags ["hadoop:node_type=datanode"]
      empty_ok false
      action :load
    end

        

    node[:server_collection]['slaves'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      @slaves.push(ip)
    end

    # add nodenames as masters
    @masters.each do |m|
      @slaves.push(m)
    end
  end
end

create_hosts "Add all datanodes" do
  hosts  slaves
  file 'slaves'
  restart  false
  #only add slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end

if node[:hadoop][:node][:type]=='datanode'
  create_hosts "Add all namenodes" do
    hosts  masters
    file 'masters'
    restart  true
 
  end
end


rightscale_marker :end

