#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# remove all datanodes from cluster
define :remove_host, :file=>'slaves', :restart=>false  do
  

  file "#{node[:hadoop][:install_dir]}/conf/#{params[:file]}" do
    owner node[:hadoop][:user]
    group node[:hadoop][:group]
    mode "0644"
    action :create
  end
    
  
  if params[:restart]
    log "Stop Slaves"
    action :restart
  end
end