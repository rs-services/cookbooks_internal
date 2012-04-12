#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin

directory "/mnt/#{node[:solr][:storage_type]}/solr" do
  action :create
  owner "tomcat"
  mode "0755"
end

link "/usr/share/tomcat6/solr" do 
  action :create
  link_type :symbolic
  to "/mnt/#{node[:solr][:storage_type]}/solr"
end

directory "/usr/share/tomcat6/solr/lib" do 
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

template "/usr/share/tomcat6/solr/solr.xml" do
  source "solr.xml"
  owner "tomcat"
end

template "/usr/share/tomcat6/solr/solrconfig.xml" do
  source "solrconfig.xml"
  owner "tomcat"
end

service "tomcat6"

rs_utils_marker :end
