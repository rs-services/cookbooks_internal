#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

include_recipe "hadoop::default"
log "Installing hadoop hadoop-env.sh to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/hadoop-env.sh" do
  source "hadoop-env.sh.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

log "Installing hadoop core-site.xml to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/core-site.xml" do
  source "core-site.xml.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

log "Installing hadoop hdfs-site.xml to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

log "Installing hadoop masters to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/masters" do
  source "masters.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

log "Installing hadoop slaves to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/slaves" do
  source "slaves.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

rs_utils_marker :end
