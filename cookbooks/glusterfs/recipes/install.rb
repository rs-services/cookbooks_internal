#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements such
# as a RightScale Master Subscription Agreement.

rightscale_marker :begin

case node[:platform]
when 'centos'
  package "fuse"
  package "glusterfs-fuse"
when 'ubuntu'
 apt_repository "glusterfs" do
   uri "http://ppa.launchpad.net/semiosis/glusterfs-3.3/ubuntu"
   distribution node['lsb']['codename']
   components ["main"]
   keyserver "keyserver.ubuntu.com"
   key "774BAC4D"
 end
 package "glusterfs-server"
when 'centos'
  package "glusterfs" # from epel
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

