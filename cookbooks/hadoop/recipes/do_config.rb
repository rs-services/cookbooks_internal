#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin


#node[:namenodes] = Array.new
        
rightscale_server_collection "namenodes" do
  tags "hadoop:node_type=namenode"
  empty_ok true
  action :load
end

ruby_block "update_namenodes" do
  block do

    node[:server_collection]['namenodes'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
      Chef::Log.info("      here #{ip}")
      node[:namenodes].push(ip)
    end    
  end
end


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
  variables(:namenodes =>node[:namenodes] )
end

log "Installing hadoop hdfs-site.xml to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/hdfs-site.xml" do
  source "hdfs-site.xml.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
end

log "masters #{node[:namenodes]}"
log "Installing hadoop masters to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/masters" do
  source "masters.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
  #variables(:namenodes =>node[:namenodes] )
end

log "slaves #{node[:namenodes]}"
log "Installing hadoop slaves to #{node[:hadoop][:install_dir]}/conf"
template "#{node[:hadoop][:install_dir]}/conf/slaves" do
  source "slaves.erb"
  owner "#{node[:hadoop][:user]}"
  group "#{node[:hadoop][:group]}"
  mode "0644"
  #variables(:namenodes =>node[:namenodes] )
end

rightscale_marker :end
