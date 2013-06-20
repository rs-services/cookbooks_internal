maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures rightscale_services_tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rightscale'
depends 'sysctl'

recipe "rightscale_services_tools::default", "Enable rightscale_services_tools"
recipe "rightscale_services_tools::vpc-nat", "Enable AWS VPC NAT instance ipforwarding and iptables"
recipe "rightscale_services_tools::vpc-nat-ha", "Configures NAT Monitor for NAT instance HA."
recipe "rightscale_services_tools::start-nat-monitor", "Start NAT monitor"
recipe "rightscale_services_tools::stop-nat-monitor", "Stop NAT monitor"

attribute "vpc_nat/other_instance_id",
  :display_name => "Instance ID of other NAT HA Instance",
  :description => "The instance ID of the instance to monitor.",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/other_route_id",
  :display_name => "VPC Route table ID",
  :description => "The routetable Id of the VPC route where the other instance is associated.",
  :required => "required",
  :recipes => [ "rightscale_services_tools::vpc-nat-ha" ]

attribute "vpc_nat/route_id",
  :display_name => "VPC Route ID of VPC Route Table",
  :description => "The route ID of the VPC route where the this instance is associated.",
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
