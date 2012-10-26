#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

set[:hadoop][:version] = '1.0.3'
set[:hadoop][:install_dir]='/home/hadoop'
set[:env][:java_home]='/usr/lib/jvm/java-6-sun'
set[:hadoop][:user]='root'
set[:hadoop][:group]='root'
default[:hadoop][:dfs][:replication]='1'

default[:hadoop][:name_dir]='/mnt/storage/logs'
default[:hadoop][:data_dir]='/mnt/storage/data'
#ports
default[:hadoop][:namenode][:address][:port]='8020'
default[:hadoop][:namenode][:http][:port]='50070'
default[:hadoop][:datanode][:address][:port]='50010'
default[:hadoop][:datanode][:ipc][:port]='50020'
default[:hadoop][:datanode][:http][:port]='50075'

# mapreduce attributes
default[:mapreduce][:input] = "input"
default[:mapreduce][:output] = "output"
default[:mapreduce][:destination] = "/mapreduce"
default[:mapreduce][:name] = "MyMapReduce"
default[:mapreduce][:cleanup] = "no"


# This is a set instead of set_unless to support start/stop when the IP changes.
set[:hadoop][:ip] = node[:cloud][:private_ips][0]

set_unless[:namenodes] = Array.new
set_unless[:hosts] = Array.new
set_unless[:datanodes] = Array.new