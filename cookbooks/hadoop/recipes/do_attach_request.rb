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


hadoop "Attach Request for #{node[:hadoop][:ip]}" do

  backend_id node[:rightscale][:instance_uuid]
  backend_ip node[:hadoop][:ip]
  node_type node[:hadoop][:node][:type]

  action :attach_request
end



rightscale_marker :end
