name             'rfx_networks_security'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rfx_networks_security'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"

recipe "rfx_networks_security::do_apf_install", "installs apf"
recipe "rfx_networks_security::do_bfd_install", "installs bfd"


#APF

#BFD
attribute "rfx_networks_security/bfd/trigger",
  :display_name => "BFD Number of failures",
  :description => "BFD Number of failures, before blocking",
  :default => "15"
