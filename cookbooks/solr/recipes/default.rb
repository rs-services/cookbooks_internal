#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin
 
log "Solr Directory: #{node[:solr][:install_dir]}"

log "Solr Storage Base Directory: /mnt/#{node[:solr][:storage_type]}/solr"
directory "/mnt/#{node[:solr][:storage_type]}/solr" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
  mode "0755"
end

log "linking /mnt/#{node[:solr][:storage_type]}/solr to #{node[:solr][:install_dir]}"
link "#{node[:solr][:install_dir]}" do 
  action :create
  link_type :symbolic
  to "/mnt/#{node[:solr][:storage_type]}/solr"
end

log "Creating Solr Lib Dir: #{node[:solr][:lib_dir]}"
directory "#{node[:solr][:lib_dir]}" do 
  action :create
  owner "#{node[:tomcat][:app_user]}"
end

log "Creating Solr Config Dir: #{node[:solr][:conf_dir]}"
directory "#{node[:solr][:conf_dir]}" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
end

log "Creating Solr Data Dir: #{node[:solr][:data_dir]}"
directory "#{node[:solr][:data_dir]}" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
end

directory "/srv/tomcat6/webapps/myapp" do
  action :create
  owner "#{node[:tomcat][:app_user]}"
end

log "Copying Solr war file to /srv/tomcat6/webapps/myapp/solr.war"
cookbook_file "/srv/tomcat6/webapps/myapp/solr.war" do
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
  mode "0644"
  purge false
end

rs_utils_marker :end
