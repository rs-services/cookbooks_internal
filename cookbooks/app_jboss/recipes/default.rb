#
# Cookbook Name:: app_jboss
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

log "  Setting provider specific settings for jboss"
node[:app][:provider] = "app_jboss"

# Defining app user and group attributes
case node[:platform]
when "ubuntu"
  node[:app][:user] = "jboss"
  node[:app][:group] = "jboss"
when "centos", "redhat"
  node[:app][:user] = "jboss"
  node[:app][:group] = "jboss"
else
  raise "Unrecognized distro #{node[:platform]}, exiting "
end

# Setting app LWRP attribute
node[:app][:destination] = "#{node[:repo][:default][:destination]}/#{node[:web_apache][:application_name]}"

# tomcat shares the same doc root with the application destination
node[:app][:root]="#{node[:app][:destination]}"

rightscale_marker :end
