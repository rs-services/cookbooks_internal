maintainer       "RightScale Inc"
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures bootstrap"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


recipe "bootstrap::sys_add_users", "adds equinix default users"
recipe "bootstrap::sys_add_groups", "adds equinix default groups"
recipe "bootstrap::mlocate", "install and update mlocate"
recipe "bootstrap::aria2c", "install aria2c"
recipe "bootstrap::net-snmp", "install and configure net-snmpd"
recipe "bootstrap::aria2c_download", "aria2c downloader"
recipe "bootstrap::rubygems", "installs rubygems"
recipe "bootstrap::register_redhat_network", "registers with redhat network"
recipe "bootstrap::cs_patch", "patches redhat image on cloudstack"

attribute "aria2c/download_dir", 
  :display_name => "Aria2C download directory",
  :description => "Location for Aria2C to download file to",
  :required => "required",
  :recipes => [ "bootstrap::aria2c_download" ]


attribute "aria2c/download_file",
  :display_name => "Aria2C File to download",
  :description => "File to download via Aria2C",
  :required => "required",
  :recipes => [ "bootstrap::aria2c_download" ]

attribute "rightscale/server_nickname", 
  :display_name => "RightScale Server Nickname", 
  :description => "RightScale Server Nickname",
  :required => "required",
  :recipes => [ "bootstrap::register_redhat_network" ]

attribute "rhn/username", 
  :display_name => "Redhat Network Username", 
  :description => "Redhat Network Username",
  :required => "required",
  :recipes => [ "bootstrap::register_redhat_network" ]

attribute "rhn/password",
  :display_name => "Redhat Network Password",
  :description => "Redhat Network Username",
  :required => "required",
  :recipes => [ "bootstrap::register_redhat_network" ]


