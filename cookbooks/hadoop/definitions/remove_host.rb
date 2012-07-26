#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# remove a host from master/slaves file.  called from detatch
define :remove_hosts, :file=>'slaves', :restart=>false  do
  slaves = File.read("#{node[:hadoop][:install_dir]}/conf/#{params[:file]}")
  replace = slaves.gsub(host, "")
  File.open("#{node[:hadoop][:install_dir]}/conf/slaves", "w") {|file| file.puts replace}
  

  if params[:restart]
    log "Stop Slaves"
    action :restart
  end
end