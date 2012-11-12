rightscale_marker :begin

template "/etc/openvpn/client.conf" do
  source "client.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :openvpn_log => node[:openvpn][:openvpn_log],
             :status_log => node[:openvpn][:status_log],
             :remote => node[:openvpn][:remote] )

  action :create
end

remote_directory "/etc/openvpn/keys" do
  cookbook "openvpn"
  source "keys"
  owner "root"
  group "root"
  mode "0600"
  action :create
end

service "openvpn" do
  action :start
end

rightscale_marker :end
