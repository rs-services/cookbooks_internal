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

#get_hosts('datanode').each do |host|
    
hadoop "Attach Request for #{node[:hadoop][:ip]}" do
  #log "  Sending remote attach request..."

  backend_id node[:rightscale][:instance_uuid]
  backend_ip node[:hadoop][:ip]
  node_type node[:hadoop][:node][:type]
  #backend_port node[:app][:port].to_i
  action :attach_request
end
#end


rightscale_marker :end
