#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
 
rightscale_marker :begin



# Check for valid prefix / dump filename
dump_file_regex = '(^\w+)(-\d{1,12})*$'
raise "Data filename  #{node[:mapreduce][:data][:prefix]} invalid.  It is restricted to word characters (letter, number, underscore) and an optional partial timestamp -YYYYMMDDHHMM.  (=~/#{dump_file_regex}/ is the ruby regex used). ex: myapp_prod_dump, myapp_prod_dump-201203080035 or myapp_prod_dump-201203" unless node[:mapreduce][:data][:prefix] =~ /#{dump_file_regex}/ ||node[:mapreduce][:data][:prefix] == ""

# Check variables and log/skip if not set
skip, reason = true, "Name not profiled"                   if node[:mapreduce][:data][:prefix] == ""
skip, reason = true, "Storage account provider not provided" if node[:mapreduce][:data][:storage_account_provider] == ""
skip, reason = true, "Container not provided"                if node[:mapreduce][:data][:container] == ""
skip, reason = true, "MapReduce is only run on a namenode"   if node[:hadoop][:node][:type] == 'datanode'

if skip
  log "  Skipping import: #{reason}"
else

  
  prefix       = node[:mapreduce][:data][:prefix]
  dumpfilepath = "/tmp/" + prefix 
  container    = node[:mapreduce][:data][:container]
  cloud        = node[:mapreduce][:data][:storage_account_provider]

  # Delete the local file.
  directory node[:mapreduce][:destination] do
    recursive true
    action :delete
  end
  
  # Obtain the data file from ROS 
  execute "Download dumpfile from Remote Object Store" do
    command "/opt/rightscale/sandbox/bin/ros_util get --cloud #{cloud} --container #{container} --dest #{dumpfilepath} --source #{prefix} --latest"
    creates dumpfilepath
    environment ({
        'STORAGE_ACCOUNT_ID' => node[:mapreduce][:data][:storage_account_id],
        'STORAGE_ACCOUNT_SECRET' => node[:mapreduce][:data][:storage_account_secret]
      })
  end

  
  #extract file to destination
  bash "Extract #{dumpfilepath} to #{node[:mapreduce][:destination]}" do
    flags "-ex"
    code <<-EOH
    tar -zxvf #{dumpfilepath} -C #{node[:mapreduce][:destination]}
    EOH
  
  end
  
  bash "Copy to hadoop" do
    flags "-ex"
    code <<-EOH
      #{node[:hadoop][:install_dir]}/bin/hadoop fs  -copyFromLocal #{node[:mapreduce][:destination]}  #{node[:mapreduce][:input]} 
    EOH
 
  end
  
  # Delete the local file.
  directory node[:mapreduce][:destination] do
    recursive true
    action :delete
  end

end

rightscale_marker :end