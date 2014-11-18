#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements such
# as a RightScale Master Subscription Agreement.

rightscale_marker :begin

case node[:platform]
when 'ubuntu'
  unless apt_repository "glusterfs" do
      uri "http://ppa.launchpad.net/semiosis/ubuntu-glusterfs-3.5/ubuntu"
      components ["main"]
      distribution node['lsb']['codename']
      keyserver "keyserver.ubuntu.com"
      key "774BAC4D"
    end
  end
  package "glusterd"
when 'centos','redhat'
  execute "create-yum-cache" do
    command "yum -q makecache"
    action :nothing
  end

  ruby_block "reload-internal-yum-cache" do
    block do
      Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
  end
  
  glusterfs "create repo" do
    version node[:glusterfs][:version]
    action :create_repo
  end
  
  package "glusterfs" # from epel
  package "glusterfs-server"
  package "attr"
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

