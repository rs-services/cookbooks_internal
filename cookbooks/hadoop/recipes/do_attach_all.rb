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

slaves = get_hosts('datanode')
masters = get_hosts('namenode')

# add nodenames as masters
masters.each do |m|
  slaves.add?(m)
end

create_hosts "Add all datanodes" do
  hosts  slaves
  file 'slaves'
  restart  false
  #only add slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end


create_hosts "Add all namenodes" do
  hosts  masters
  file 'masters'
  restart  true
  # only add masters to datanode hosts
  only_if node[:hadoop][:node][:type]=='datanode'
end


rightscale_marker :end

