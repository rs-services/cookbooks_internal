#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin


right_link_tag "hadoop:node_type=#{node[:hadoop][:node][:type]}"
if node[:hadoop][:node][:type]=='namenode'
  log "  Format namenode #{node[:hadoop][:dns][:namenode][:fqdn]}"
  execute "namenode formt" do
    command "#{node[:hadoop][:install_dir]}/bin/hadoop namenode -format"
    action :run
    not_if "test -e /mnt/storage/logs"
  end
end


hadoop "start hadoop" do
  action :start
end


rightscale_marker :end
