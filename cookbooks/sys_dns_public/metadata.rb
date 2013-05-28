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
