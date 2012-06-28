#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# update slaves file with new host.  Called from handel_attach
define :add_host,:restart=>false, :file=>'slaves' do
  
  file = File.open("#{node[:hadoop][:install_dir]}/conf/#{params[:file]}",'a')
  file.puts(params[:name])
  
  if params[:restart]
    log "Start new nodes"
    hadoop "Start hadoop" do
      action :start
    end
  end
  
end