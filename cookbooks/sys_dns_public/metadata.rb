name             'sys_dns_public'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures sys_dns_public'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'rightscale'
depends 'sys_dns'

recipe "sys_dns_public::default", "sets the public ip address"

attribute "sys_dns/id",
  :display_name => "DNS Record ID",
  :description =>
    "The unique identifier that is associated with the DNS A record" +
    " of the server. The unique identifier is assigned by the DNS provider" +
    " when you create a dynamic DNS A record. This ID is used to update" +
    " the associated A record with the private IP address of the server" +
    " when this recipe is run. If you are using DNS Made Easy as" +
    " your DNS provider, a 7-digit number is used (e.g., 4403234)." +
    " If you are using Cloud DNS, provide both Domain ID and Record ID" +
    " (e.g., DomainID:A-RecordID). Example: 111021",
  :required => "required"
