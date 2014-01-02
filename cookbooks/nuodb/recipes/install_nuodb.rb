# 
# Cookbook Name:: lb_haproxy_db::default
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin


# Sinlge tag right now till type install etc.. are implemented
#right_link_tag "nuodb:nuodb_type=#{node[:noudb][:nuodb_type]}"
#right_link_tag "nuodb:nuodb_type=broker"

log "Downloading Nuodb"

remote_file "/tmp/nuodb.rpm" do
  source "#{node[:nuodb][:nuodb_download_url]}"
  owner "root"
  mode "0644"
end

log "Installing Nuodb"

# Install nuodb package. Need to determine location of this
package "nuodb" do
  source "/tmp/nuodb.rpm"
  provider Chef::Provider::Package::Rpm
  action :install
end

cookbook_file "/etc/init.d/nuoagent" do
  source "nuoagent"
  cookbook "nuodb"
  owner "root"
  mode 00755
end

# Create nuoagent service.
service "nuoagent" do
  supports :restart => true, :status => true, :start => true, :stop => true
  action :enable
end

# Install nuodb properties file 
template "/opt/nuodb/etc/default.properties" do
  source "default.properties.erb"
  cookbook "nuodb"
  owner "root"
  mode 00664
  variables( 
    :nuodb_broker_flag => node[:nuodb][:nuodb_broker_flag],
    :nuodb_domain => node[:nuodb][:nuodb_domain],
    :nuodb_domain_password => node[:nuodb][:nuodb_domain_password],
    :nuodb_port => node[:nuodb][:nuodb_port],
    :nuodb_peer => node[:nuodb][:nuodb_peer],
    :nuodb_alt_addr => node[:nuodb][:nuodb_alt_addr],
    :nuodb_advertise_alt => node[:nuodb][:nuodb_advertise_alt],
    :nuodb_bindir => node[:nuodb][:nuodb_bindir],
    :nuodb_portrange => node[:nuodb][:nuodb_portrange],
    :nuodb_broadcast => node[:nuodb][:nuodb_broadcast],
    :nuodb_require_connect_key => node[:nuodb][:nuodb_require_connect_key]
  )
  notifies :restart, resources(:service => "nuoagent")
end

rightscale_marker :end
