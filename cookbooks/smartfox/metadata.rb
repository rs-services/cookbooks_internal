name             'smartfox'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures smartfox'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "repo"

recipe "smartfox::install", "Installs Smartfox"

attribute "smartfox/jmxremote_host",
  :description => "Remote IP of licence server",
  :recipes     => ["smartfox::install"],
  :type        => "string",
  :display     => "smartfox/jmxremote_host",
  :required    => "required"

attribute "smartfox/rmi_server_hostname",
  :description => "DNS name of this Smartfox host",
  :recipes     => ["smartfox::default"],
  :type        => "string",
  :display     => "smartfox/rmi_server_hostname",
  :required    => "required"
