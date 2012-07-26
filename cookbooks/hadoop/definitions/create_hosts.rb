#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# update the masters or slaves files.  Ran from do_attach_all
define :create_hosts ,:restart=>false, :hosts=>Array.new, :file=>'slaves' do
  file = File.new("#{node[:hadoop][:install_dir]}/conf/#{params[:file]}",'w')
  
  
  params[:hosts].each do |h|
    file.puts(h)
  end
  file.close
        
  if !params[:hosts].empty? and params[:restart]
    log "Start the nodes"
    hadoop "Start hadoop" do
      action :start
    end
  end
end