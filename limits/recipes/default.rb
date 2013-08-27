#
# Cookbook Name:: limits
# Recipe:: default
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

template "/etc/security/limits.conf" do
  source "limits.conf.erb"
  mode "0444"
  owner "root"
  group "root"
  backup false
  variables({
   :priority => node[:limits][:priority],
  })
end

rightscale_marker :end
