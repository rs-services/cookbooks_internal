#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

log "  Installing Hadoop "
include_recipe"bootstrap::aria2c"

bash "Download Hadoop" do
  user "root"
  cwd '/tmp'
  code <<-EOF
  aria2c http://ps-cf.rightscale.com/hadoop/hadoop-#{node[:hadoop][:version]}-bin.tar.gz -x 16 -d /tmp
  EOF
end

bash "install hadoop" do
  flags "-ex"
  code <<-EOH
      tar xzf /tmp/hadoop-#{node[:hadoop][:version]}-bin.tar.gz -C /home/
  EOH
  only_if do ::File.exists?("/tmp/hadoop-#{node[:hadoop][:version]}-bin.tar.gz")  end
end

directory "#{node[:hadoop][:install_dir]}" do
  action :delete
end

link "#{node[:hadoop][:install_dir]}" do 
  action :create
  link_type :symbolic
  to "/home/hadoop-#{node[:hadoop][:version]}" 
end

rightscale_marker :end