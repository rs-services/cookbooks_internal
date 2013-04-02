name             'DS389'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures 389-DS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "rightscale_services_tools"
depends "sys_firewall"
depends "sys_dns"
depends "sysctl"

recipe "DS389::default", "Installs 389 ds"

attribute "DS389/install_type",
  :display_name => "Install Type(Package/Source)",
  :description => "Install Type(Package/Source)",
  :choice => [ "package", "source" ],
  :required => "optional",
  :default => "package"

attribute "DS389/Hostname",
  :display_name => "Hostname",
  :description => "hostname",
  :required => 'required'
