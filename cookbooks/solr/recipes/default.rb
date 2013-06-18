#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rightscale_marker :begin
 
log "Solr Directory: #{node[:solr][:install_dir]}"

log "Solr Storage Base Directory: /mnt/#{node[:solr][:storage_type]}/solr"
directory "/mnt/#{node[:solr][:storage_type]}/solr" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0755"
  recursive true
  notifies :restart, "service[tomcat6]", :delayed
end

directory "#{node[:solr][:install_dir]}" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0755"
  recursive true
end

log "Creating Solr Lib Dir: #{node[:solr][:lib_dir]}"
directory "#{node[:solr][:lib_dir]}" do 
  action :create
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  recursive true
  mode "0644"
end

log "Creating Solr Config Dir: #{node[:solr][:conf_dir]}"
directory "#{node[:solr][:conf_dir]}" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0755"
end

#log "Creating Solr Data Dir: #{node[:solr][:data_dir]}"
#directory "#{node[:solr][:data_dir]}" do
#  action :create
#  owner "#{node[:tomcat][:app_user]}"
#end

directory "/home/webapps/#{node[:web_apache][:application_name]}" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
  recursive true
end

log "Copying Solr war file to /srv/tomcat6/webapps/#{node[:web_apache][:application_name]}/solr.war"
cookbook_file "/home/webapps/#{node[:web_apache][:application_name]}/solr.war" do
  source "apache-solr-3.5.0.war"
  owner "#{node[:tomcat][:app_user]}" 
  mode "0644"
end

log "Copying Libs to #{node[:solr][:lib_dir]}"
remote_directory "#{node[:solr][:lib_dir]}" do
  source "lib"
  files_backup 0
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0755"
  purge false
end

log "linking /mnt/#{node[:solr][:storage_type]}/solr to #{node[:solr][:data_dir]}"
link "#{node[:solr][:data_dir]}" do
  action :delete
end

link "#{node[:solr][:data_dir]}" do 
  action :create
  link_type :symbolic
  to "/mnt/#{node[:solr][:storage_type]}/solr"
  notifies :restart, "service[tomcat6]", :delayed
end

service "tomcat6"

if node[:sys_firewall][:enabled] == "enabled"
  include_recipe "iptables"
  sys_firewall "8000"
end

rightscale_marker :end
