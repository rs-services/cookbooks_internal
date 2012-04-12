#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin

solr_dir='/usr/share/tomcat6/solr' 
log "#{solr_dir}"

directory "/mnt/#{node[:solr][:storage_type]}/solr" do
  action :create
  owner "tomcat"
  mode "0755"
end

link "#{solr_dir}" do 
  action :create
  link_type :symbolic
  to "/mnt/#{node[:solr][:storage_type]}/solr"
end

directory "#{solr_dir}/lib" do 
  action :create
  owner "tomcat"
end

directory "#{solr_dir}/conf" do
  action :create
  owner "tomcat"
end

directory "/srv/tomcat6/webapps/myapp" do
  action :create
  owner "tomcat"
end

remote_file "/srv/tomcat6/webapps/myapp/solr.war" do
  source "https://rightscale-services.s3.amazonaws.com/apache-solr-3.5.0%2Fdist%2Fapache-solr-3.5.0.war"
  owner "tomcat" 
  mode "0644"
end

template "#{solr_dir}/solr.xml" do
  source "solr.xml"
  owner "tomcat"
end

template "#{solr_dir}/conf/solrconfig.xml" do
  source "solrconfig.xml"
  owner "tomcat"
end

template "#{solr_dir}/conf/schema.xml" do
  source "schema.xml"
  owner "tomcat"
end

service "tomcat6"

rs_utils_marker :end
