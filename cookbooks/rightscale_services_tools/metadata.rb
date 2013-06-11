maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures rightscale_services_tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rightscale'
depends 'sysctl'

recipe "rightscale_services_tools::default", "enables rightscale_services_tools"
recipe "rightscale_services_tools::vpc-nat", "enables AWS VPC NAT Host ipforwarding and iptables"
