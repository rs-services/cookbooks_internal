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

right_link_tag "hadoop:node_type=#{node[:hadoop][:node][:type]}"
if node[:hadoop][:node][:type]=='namenode'
  log "  Format namenode"
  execute "namenode formt" do
    command "#{node[:hadoop][:install_dir]}/bin/hadoop namenode -format"
    action :run
    not_if "test -e /mnt/storage/logs"
  end
end

add_public_key(node[:ssh][:public_ssh_key])


hadoop "start hadoop" do
  action :start
end


rightscale_marker :end
