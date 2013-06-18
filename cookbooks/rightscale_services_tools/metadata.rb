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
recipe "rightscale_services_tools::vpc-nat-ha", "enables AWS VPC NAT HA with another NAT Host"


attribute "vpc_nat/other_instance_id",
  :display_name => "Instance ID of other HA host",
  :description => "The instance ID of the host to monitor.",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/other_route_id",
  :display_name => "VPC Route ID of VPC route ",
  :description => "The route ID of the VPC route where the other instance is associated.",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/route_id",
  :display_name => "VPC Route ID of VPC Route Table",
  :description => "The route ID of the VPC route where the other instance is associated.",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/aws_account_id",
  :display_name => "AWS Account Id ",
  :description => "Use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID)",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/aws_account_secret",
  :display_name => "AWS Account Secret Key",
  :description => "Use your AWS secret access key (e.g., cred:AWS_SECRET_ACCESS_KEY)",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]
