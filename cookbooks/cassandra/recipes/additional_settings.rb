#
# Cookbook Name:: cassandra
# Recipe:: additional_settings
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Additional Settings
# 
###################################################

#

execute 'sudo bash -c "ulimit -n 32768"'
execute 'echo "* soft nofile 32768" | sudo tee -a /etc/security/limits.conf'
execute 'echo "* hard nofile 32768" | sudo tee -a /etc/security/limits.conf'
execute 'sync'
execute 'echo 3 > /proc/sys/vm/drop_caches'

# Open ports for communications in Rackspace.
# This is HORRIBLE security. 
# Make sure to properly configure your cluster here.
#if node[:cloud][:provider] == "rackspace" and node[:platform] == "centos"
#  execute 'sudo service iptables stop' do
#    ignore_failure true
#  end
#end
