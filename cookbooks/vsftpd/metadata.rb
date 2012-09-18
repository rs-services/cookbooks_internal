name    "vsftpd"
maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures vsftpd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "rightscale"
depends "block_device"

recipe "vsftpd::install_server", "installs vsftpd server"

attribute "vsftpd/login",
  :display_name => "FTP Username", 
  :description => "FTP Username",
  :required => "required",
  :recipes => [ "vsftpd::install_server" ]

attribute "vsftpd/password",
  :display_name => "FTP Password",
  :description => "FTP Password",
  :required => "required",
  :recipes => [ "vsftpd::install_server" ]

attribute "vsftpd/pasv_min_port",
  :display_name => "Passive Minimum Port",
  :description => "Passive Minimum Port, should be 1024 or higher",
  :required => "optional",
  :default => "1025", 
  :recipes => [ "vsftpd::install_server" ]

attribute "vsftpd/pasv_max_port",
  :display_name => "Passive Maximum Port",
  :description => "Passive Maximum Port, should not be above 65535",
  :required => "optional",
  :default => "1128",
  :recipes => [ "vsftpd::install_server" ]
