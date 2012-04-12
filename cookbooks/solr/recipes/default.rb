#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin

directory "/usr/share/tomcat6/solr" do 
  action :create
end

directory "/usr/share/tomcat6/solr/lib" do 
  action :create
 end

remote_file "/srv/tomcat6/webapps/solr.war" do
  source "https://rightscale-services.s3.amazonaws.com/apache-solr-3.5.0%2Fdist%2Fapache-solr-3.5.0.war"
 end
rs_utils_marker :end
