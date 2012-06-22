#
# Cookbook Name:: cassandra
# Recipe:: setup_repos
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Setup Repositories
# 
###################################################

case node[:platform]
  when "ubuntu", "debian"
    include_recipe "apt"

    # Adds the Cassandra repo:
    if node[:setup][:deployment] == "08x" or node[:setup][:deployment] == "07x" or node[:setup][:deployment] == "10x"  or node[:setup][:deployment] == "11x"   
      apt_repository "cassandra-repo" do
        uri "http://www.apache.org/dist/cassandra/debian"
        components [node[:setup][:deployment], "main"]
        keyserver "keys.gnupg.net"
        key "2B5C1B00"
        action :add
      end
    end


  when "centos", "redhat", "fedora"
    if node[:platform] == "fedora"
      distribution="Fedora"
    else
      distribution="EL"
    end

    # Install EPEL (Extra Packages for Enterprise Linux) repository  Installing for x86_64 only...
    epelInstalled = File::exists?("/etc/yum.repos.d/epel.repo") or File::exists?("/etc/yum.repos.d/epel-testing.repo")
    if !epelInstalled
          execute "rpm -Uvh --aid http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-7.noarch.rpm"
    end

    execute "yum clean all"
end
