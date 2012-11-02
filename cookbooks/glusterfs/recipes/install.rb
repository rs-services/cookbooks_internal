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
 package "glusterd"
when 'centos'
  package "glusterfs" # from epel
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

