#opens firewall ports



rightscale_marker :begin


sys_firewall "111" do
    ip_addr "any"
    protocol "udp"
    enable true
    action :update
end

sys_firewall "111" do
    ip_addr "any"
    protocol "tcp"
    enable true
    action :update
end

sys_firewall 2049
sys_firewall 1110 
sys_firewall 4045

node["nfs"]["port"].each do |k,v|
  log "adding udp rule for port #{k}:#{v}"
  sys_firewall v do 
    ip_addr "any"
    protocol "udp"
    enable true
    action :update
  end
  log "adding tcp rule for port #{k}:#{v}"
  sys_firewall v do 
    ip_addr "any"
    protocol "tcp"
    enable true
    action :update
  end
end

bash "restart-iptables" do
  user "root"
  cwd "/tmp"
  code <<-EOF
/usr/sbin/rebuild-iptables
EOF
end

rightscale_marker :end
