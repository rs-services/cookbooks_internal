maintainer       "RightScale Professional Services"
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures nginx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "rightscale"
depends "sys_firewall"


recipe "nginx::install", "Installs nginx from package manager"
recipe "nginx::lb_config", "sets up the lb"

