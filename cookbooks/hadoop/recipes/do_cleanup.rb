#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
 
rightscale_marker :begin


raise "This only runs if mapreduce/cleanup==yes: " if node[:mapreduce][:cleanup]=="no"
raise "MapReduce recipes run on a namenode only: hadoop/node/type=#{node[:hadoop][:node][:type]} " if node[:hadoop][:node][:type] == 'datanode'

if node[:mapreduce][:cleanup]=="yes"
  directory  "#{node[:mapreduce][:destination]}" do
    recursive true
    action :delete
  end
  
  bash "Remove hadoop directories" do
    flags "-ex"
    ignore_failure true # don't fail script if dirs already exist.
    code <<-EOH
      #{node[:hadoop][:install_dir]}/bin/hadoop fs -rmr #{node[:mapreduce][:output]} #{node[:mapreduce][:input]}      
    EOH
   
  end
end
