#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin


log "  Remote recipe executed by do_attach_request"

  hadoop 'remote_recipe for :attach' do
    backend_id node[:remote_recipe][:backend_id]
    backend_ip node[:remote_recipe][:backend_ip]
    node_type node[:remote_recipe][:node_type]
    action :attach
  end

rightscale_marker :end
