maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures openvpn"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends "rightscale"
depends "sys_firewall"
depends "sysctl"

recipe "openvpn::default", "installs openvpn base package"
recipe "openvpn::install_server", "installs openvpn server"
recipe "openvpn::install_client", "installs openvpn client"

attribute "openvpn/ip_block", 
  :display_name => "ip block to serve via dhcp", 
  :description => "ip block to serve via dhcp",
  :required => "optional",
  :default => "192.168.0.0",
  :recipes => [ "openvpn::install_server" ]

attribute "openvpn/netmask", 
  :display_name => "ip netmask",
  :description => "ip netmask",
  :required => "optional",
  :default => "255.255.255.0",
  :recipes => [ "openvpn::install_server" ]

attribute "openvpn/remote",
  :display_name => "OpenVPN Server",
  :description => "OpenVPN Server",
  :required => "required",
  :recipes => [ "openvpn::install_client" ]

attribute "openvpn/routed_ip",
  :display_name => "Routed IP",
  :description => "IP to route over vpn",
  :required => "optional",
  :recipes => [ "openvpn::install_server" ]

attribute "openvpn/routed_subnet",
  :display_name => "Routed Subnet",
  :description => "Subnet to route over vpn",
  :required => "optional",
  :recipes => [ "openvpn::install_server" ]
