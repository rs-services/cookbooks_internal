#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install Cassandra
# 
###################################################
#
#

# Not sure we need this?  
execute "clear-data" do
  command "rm -rf /var/lib/cassandra/data/system"
  action :nothing
end

#service "cassandra" do 
#  supports :status => true, :restart => true, :reload => true
#  action [ :enable, :start ]
#end

# Sets up a user to own the data directories
node[:internal][:package_user] = "cassandra"

# Installs the latest Cassandra version depending on your deployment choice
if node[:setup][:deployment] == "08x" or node[:setup][:deployment] == "07x" or  node[:setup][:deployment] == "10x" or  node[:setup][:deployment] == "11x"
  case node[:platform]
    when "ubuntu", "debian"
      package "cassandra" do
        notifies :run, resources(:execute => "clear-data"), :immediately
      end

    when "centos", "redhat", "fedora"
#   Download cassandra rpm based on OS choice..  (hard set to 8 for the time being)
       execute "rpm -Uvh http://cassandra-rpm.googlecode.com/files/apache-cassandra-0.8.5-0.el5.noarch.rpm"
#      package "cassandra" do
#        notifies :run, resources(:execute => "clear-data"), :immediately
#      end
  end
end

# Drop the config.
template "/etc/cassandra/cassandra-env.sh" do
   owner "cassandra"
   group "cassandra"
   mode "0755"
   source "cassandra-env.sh.erb"
end

template "/etc/cassandra/cassandra.yaml" do
   owner "cassandra"
   group "cassandra"
   mode "0644"
   source "cassandra.yaml.erb"
end

template "/etc/cassandra/cassandra-topology.properties" do
	owner "cassandra"
	group "cassandra"
	mode "0644"
	source "cassandra-topology.properties.erb"
	# Pass the topology array as 't' to the template.
	#variables(
	#	:t => t
	#)
#   notifies :restart , resources(:service => "cassandra")
end
