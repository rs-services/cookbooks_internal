#
# Cookbook Name:: cassandra
# Recipe:: required_packages
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install the Required Packages
# 
###################################################


case node[:platform]
  when "ubuntu", "debian"
    # Ensure all native components are up to date
      execute 'sudo apt-get -y upgrade'
	  
    
  when "centos", "redhat", "fedora"
    # Ensure all native components are up to date
    execute 'sudo yum -y update'
end
