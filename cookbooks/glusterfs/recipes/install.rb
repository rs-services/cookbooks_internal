#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements such
# as a RightScale Master Subscription Agreement.

rightscale_marker :begin

case node[:platform]
when 'ubuntu'

  log "===> Installing nfs-common"
  package "nfs-common"

  log "===> Installing glusterfs package"
  cookbook_file "/tmp/#{node[:glusterfs][:client][:pkg_name]}" do
    source node[:glusterfs][:client][:pkg_name]
    mode "0644"
  end
  dpkg_package "glusterfs" do
    source "/tmp/#{node[:glusterfs][:client][:pkg_name]}"
    action :install
  end

when 'centos'
  package "glusterfs"       # from epel
  package "glusterfs-fuse"  #
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

