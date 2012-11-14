maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Installs/configures a MySQL database client and server."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"
depends "sys_firewall"

recipe  "db_mongo::default", "Set the DB MySQL provider. Sets version and node variables specific to the chosen MySQL version."


# == Default attributes
#

# == Default server attributes
#

attribute "mongo/replSet", 
  :display_name => "Mongo Replica Set Name",
  :description => "Mongo Replica Set Name",
  :required => "optional"
