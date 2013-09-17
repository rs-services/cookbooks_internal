name             'apache_mod_header'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures apache_mod_header'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "web_apache"

recipe "apache_mod_header::default", "enables mod_headers, and restarts apache"
recipe "apache_mod_header::set_app_server_name", "sets the AppServerName header"

attribute "apache_mod_header/app_server_name",
  :display_name => "Name to set header to",
  :description => "Name to set header to",
  :required => "required",
  :recipes => [ "apache_mod_header::set_app_server_name" ]
