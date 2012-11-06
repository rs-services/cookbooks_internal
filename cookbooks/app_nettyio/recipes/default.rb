#
# Cookbook Name:: netty.io
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

log "  Setting provider specific settings for tomcat"
node[:app][:provider] = "app_nettyio"

# we do not care about version number here.
# need only the type of database adapter
#node[:app][:db_adapter] = node[:db][:provider_type].match(/^db_([a-z]+)/)[1]

# Setting app LWRP attribute
node[:app][:destination] = "#{node[:repo][:default][:destination]}/#{node[:web_apache][:application_name]}"

# tomcat shares the same doc root with the application destination
node[:app][:root]="#{node[:app][:destination]}"

#uninstall packages
node[:app][:uninstall_packages] =  value_for_platform(
  ["centos", "redhat"] => {
    "default" => [
      "jdk"
    ]
  },
  "ubuntu" => {
    "default" => [ ]
  }
)


#install openjdk packages
node[:app][:packages] = value_for_platform(
  ["centos", "redhat"] => {
    "default" => [
      "java-1.6.0-openjdk",
      "java-1.6.0-openjdk-devel"
    ]
  },
  "ubuntu" => {
    "default" => [
      "openjdk-6-jdk"
    ]
  }
)
rightscale_marker :end