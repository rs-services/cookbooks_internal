maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Installs/configures a MySQL database client and server."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "12.1.0"

supports "centos", "~> 5.8"
supports "redhat", "~> 5.8"
supports "ubuntu", "~> 10.04.0"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"

recipe  "db_oracle::default", "Set the DB MySQL provider. Sets version and node variables specific to the chosen MySQL version."

attribute "db_oracle",
  :display_name => "General Database Options",
  :type => "hash"

# == Default attributes
#
