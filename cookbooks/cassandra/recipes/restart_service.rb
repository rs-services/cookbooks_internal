#
# Cookbook Name:: cassandra
# Recipe:: restart_service
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Write Configs and Start Services
# 
###################################################


# Restart the service
service "cassandra" do
    supports :restart => true
    action :restart
end

