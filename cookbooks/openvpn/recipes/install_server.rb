rightscale_marker :begin

template "/etc/openvpn/server.conf" do
  source "server.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :openvpn_log => node[:openvpn][:openvpn_log],
             :status_log => node[:openvpn][:status_log],
             :ip_block => node[:openvpn][:ip_block],
             :netmask => node[:openvpn][:netmask],
             :routed_ip => node[:openvpn][:routed_ip],
             :routed_subnet => node[:openvpn][:routed_subnet]
             :vpnPort => node[:openvpn][:vpn_port]
             :vpnProtocol => node[:openvpn][:vpn_protocol]
             :devType => node[:openvpn][:dev_type]
            )
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

template "/etc/iptables.snat" do
  source "iptables.snat.erb"
  owner  "root"
  group  "root"
  mode   "0644"
  variables( :ip_block => node[:openvpn][:ip_block],
             :netmask => node[:openvpn][:netmask] )
  action :create
end

sysctl "net.ipv4.ip_forward" do
  value "1"
  action :set
end

sys_firewall node[:openvpn][:vpn_port] do
  protocol node[:openvpn][:vpn_protocol]
  enable true
  action :update
end

service "openvpn" do
  action :start
end

right_link_tag "openvpn:role=server" do
  action :publish
end
rightscale_marker :end
