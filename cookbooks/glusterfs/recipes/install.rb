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
   uri "http://ppa.launchpad.net/semiosis/glusterfs-3.2/ubuntu"
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

  remote_file "/etc/yum.repos.d/gluster.epel.repo" do
    source "http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.2/EPEL.repo/glusterfs-epel.repo"
    owner "root"
    group "root"
    mode 0644
    action :create
    notifies :run, "execute[create-yum-cache]", :immediately
    notifies :create, "ruby_block[reload-internal-yum-cache]", :immediately
  end
  package "glusterfs" # from epel
  package "glusterfs-server"
  package "attr"
 else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

