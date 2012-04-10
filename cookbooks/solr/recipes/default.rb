#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin
class Chef::Recipe
  include RightScale::Utils::Helper
end

log "Memory = " + RightScale::Utils::Helper.percent_of_memory(node, 100)

directory "/usr/share/tomcat6/solr" do 
  action :create
end

directory "/usr/share/tomcat6/solr/lib" do 
  action :create
 end
rs_utils_marker :end
