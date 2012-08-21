#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
 
rightscale_marker :begin


raise "This only runs if mapreduce/cleanup==yes: " if node[:mapreduce][:cleanup]=="yes"
raise "MapReduce recipes run on a namenode only: hadoop/node/type=#{node[:hadoop][:node][:type]} " if node[:hadoop][:node][:type] == 'datanode'


directory  "#{node[:mapreduce][:destination]}" do
  recursive true
  action :delete
end
  
bash "Remove hadoop directories" do
  flags "-ex"
  code <<-EOH
      status=`#{node[:hadoop][:install_dir]}/bin/hadoop fs -rmr #{node[:mapreduce][:output]} #{node[:mapreduce][:input]}`
       if [ $status -eq 0 ];then
        echo "removed directories from hadoop"
       fi
  EOH
end
