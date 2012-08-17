#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
 
rightscale_marker :begin


raise "MapReduce is only run on a namenode" if node[:hadoop][:node][:type] != 'datanode'


bash "Make hadoop directories" do
  flags "-ex"
  code <<-EOH
      #{node[:hadoop][:install_dir]}/bin/hadoop fs -mkdir #{node[:mapreduce][:input]} #{node[:mapreduce][:output]} 
  EOH
  
end

hadoop "code update" do
  destination node[:mapreduce][:destination]
  action :code_update
end


bash "Compile MapReduce JAVA Code" do
  flags "-ex"
  code <<-EOH
      javac -classpath #{node[:hadoop][:install_dir]}/hadoop-core-1.0.3.jar #{node[:mapreduce][:compile]}
      jar -cvf /root/#{node[:mapreduce][:name]}.jar -C #{node[:mapreduce][:destination]} .
  EOH
  
end

bash "Run MapReduce Command #{node[:mapreduce][:command]}" do
  flags "-ex"
  code <<-EOH
       #{node[:hadoop][:install_dir]}/bin/hadoop #{node[:mapreduce][:command]} #{node[:mapreduce][:input]} #{node[:mapreduce][:output]}
  EOH
  
end
dumpfilename = node[:mapreduce][:data][:name]+"-output" + "-" + Time.now.strftime("%Y%m%d%H%M") + ".zip"
dumpfilepath = "/tmp/#{dumpfilename}"




bash "Output data to ROS" do
  flags "-ex"
  code <<-EOH
       #{node[:hadoop][:install_dir]}/bin/hadoop -copyToLocal /tmp/output #{node[:mapreduce][:output]}
       cd /tmp/output; zip -r #{dumpfilepath}.zip .
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

# Delete the local file
file dumpfilepath do
  backup false
  action :delete
end
file "/tmp/output" do
  backup false
  action :delete
end

rightscale_marker :end