#
# Cookbook Name:: app
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin


# Adding iptables rule to allow hadoop servers connections
  sys_firewall "Open this appserver's ports to all loadbalancers" do
    machine_tag "hadoop:node_type=namenode"
    port node[:hadoop][:ports]
    enable true
    action :update
  end
  sys_firewall "Open this appserver's ports to all loadbalancers" do
    machine_tag "hadoop:node_type=datanode"
    port node[:hadoop][:ports]
    enable true
    action :update
  end

rs_utils_marker :end
