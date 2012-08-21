#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
 
rightscale_marker :begin

include_recipe "hadoop::do_cleanup"

raise "MapReduce is only run on a namenode" if node[:hadoop][:node][:type] == 'datanode'


directory "#{node[:mapreduce][:destination]}/source" do
  recursive true
  action :create
end

hadoop "code update" do
  destination "#{node[:mapreduce][:destination]}/source"
  action :code_update
end

directory "#{node[:mapreduce][:destination]}/classes" do
  recursive true
  action :create
end


bash "Compile MapReduce JAVA Code" do
  flags "-ex"
  code <<-EOH
       #{node[:mapreduce][:compile]}
      jar -cvf #{node[:mapreduce][:destination]}/#{node[:mapreduce][:name]}.jar -C #{node[:mapreduce][:destination]}/classes .
  EOH
  
end

bash "Run MapReduce Command #{node[:mapreduce][:command]}" do
  flags "-ex"
  code <<-EOH
       #{node[:hadoop][:install_dir]}/bin/hadoop #{node[:mapreduce][:command]}
  EOH
  
end
dumpfilename = node[:mapreduce][:data][:output_prefix] + "-" + Time.now.strftime("%Y%m%d%H%M")+".tar.gz"
dumpfilepath = "#{node[:mapreduce][:destination]}/#{dumpfilename}"

directory "#{node[:mapreduce][:destination]}/output" do
  action :create
end


bash "Output data to ROS" do
  flags "-ex"
  code <<-EOH
       #{node[:hadoop][:install_dir]}/bin/hadoop fs -copyToLocal #{node[:mapreduce][:output]}/* #{node[:mapreduce][:destination]}/output
  EOH
end

bash "Tar output file " do
  flags "-ex"
  code <<-EOH
       cd #{node[:mapreduce][:destination]}/output; tar -zcvf #{dumpfilepath} .
  EOH
end

container   = node[:mapreduce][:data][:container]
cloud       = node[:mapreduce][:data][:storage_account_provider]

# Upload the files to ROS
execute "Upload dumpfile to Remote Object Store" do
  command "/opt/rightscale/sandbox/bin/ros_util put --cloud #{cloud} --container #{container} --dest #{dumpfilename} --source #{dumpfilepath}"
  environment ({
      'STORAGE_ACCOUNT_ID' => node[:mapreduce][:data][:storage_account_id],
      'STORAGE_ACCOUNT_SECRET' => node[:mapreduce][:data][:storage_account_secret]
    })
end


rightscale_marker :end