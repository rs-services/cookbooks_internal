#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements such
# as a RightScale Master Subscription Agreement.

rightscale_marker :begin

case node[:platform]
when 'ubuntu'
  # TODO Add Ubuntu support
  #      Should use apt-add-repository and apt-get install the package
  #      (not fetch it from a URL manually)
  #
  #require 'uri'
  #include_recipe "aria2"
  #
  #URL = node[:glusterfs][:package_url]
  #PKG = URL.gsub(/.*\//, '') # strip off path
  #
  #log "===> Downloading #{URL}"
  #bash "download_gluster_pkg" do
  #  cwd '/tmp'
  #  code <<-EOF
  #    aria2c #{URL}
  #  EOF
  #end
  #
  #log "===> Installing nfs-common"
  #package "nfs-common"
  #
  #log "===> Installing glusterfs package"
  #dpkg_package "glusterfs" do
  #  source "/tmp/#{URI.unescape(PKG)}"
  #  action :install
  #end
when 'centos'
  package "glusterfs" # from epel
else
  raise "Unsupported platform '#{node[:platform]}'"
end

rightscale_marker :end

