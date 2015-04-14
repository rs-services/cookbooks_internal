#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements such
# as a RightScale Master Subscription Agreement.
marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end

case node[:platform]
when 'ubuntu'
  unless apt_repository "glusterfs" do
      uri "http://ppa.launchpad.net/semiosis/ubuntu-glusterfs-3.5/ubuntu"
      components ["main"]
      distribution node['lsb']['codename']
      keyserver "keyserver.ubuntu.com"
      key "774BAC4D"
      action :nothing
    end
    resource("apt_repository[glusterfs]", :add)
  end
  package "glusterfs-server"
when 'centos','redhat'
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

  class Chef::Resource::RubyBlock
    include Chef::MachineTagHelper
  end

  include_recipe "machine_tag::default"
