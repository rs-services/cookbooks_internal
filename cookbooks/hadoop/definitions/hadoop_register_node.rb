#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# registers the private IP of the namenode host in the DNS service.
define :hadoop_register_node do

  # Set master DNS
  # Do this first so that DNS can propagate while the recipe runs
  private_ip = node[:cloud][:private_ips][0]
  log "  Setting nodename  #{node[:hadoop][:dns][:namenode][:fqdn]} to #{private_ip}"
  sys_dns "default" do
    id node[:hadoop][:dns][:namenode][:id]
    address private_ip
    action :set_private
  end


end
