maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Setup port forwarding and iptables for NAT instance"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends 'rightscale'
depends 'sysctl'

recipe 'vpc-nat::default', "Setup port forwarding and iptables for NAT instance"