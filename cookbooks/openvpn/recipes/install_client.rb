rightscale_marker :begin

results = rightscale_server_collection "openvpn_server" do
  tags ["openvpn:role=server"]
  secondary_tags ["server:private_ip_0=*"]
  empty_ok false
  action :nothing
end

results.run_action(:load)
openvpn_servers = []
if node["server_collection"]["mongo_replicas"]
log "Server Collection Found"
node["server_collection"]["mongo_replicas"].to_hash.values.each do |tags|
  openvpn_servers << RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
end

template "/etc/openvpn/client.conf" do
  source "client.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :openvpn_log => node[:openvpn][:openvpn_log],
             :status_log => node[:openvpn][:status_log],
             :remote => openvpn_servers )

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
