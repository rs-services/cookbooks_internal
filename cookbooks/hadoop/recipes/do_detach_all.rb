#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

class Chef::Recipe
  include RightScale::Hadoop::Helper
end

hosts = get_hosts('datanode')

remove_hosts "Remove all datanodes" do
  hosts  hosts
  file 'slaves'
  restart  false
  #only remove slaves to namenode hosts
  only_if node[:hadoop][:node][:type]=='namenode' 
end



rs_utils_marker :end

