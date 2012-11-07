maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures mongo"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends "rightscale"
depends "block_device"
depends "rightscale_services_tools"
depends "sysctl"
depends "sys_firewall"

recipe "mongo::default", "sets up default mongo settings"
recipe "mongo::install_server", "installs mongo" 
recipe "mongo::setup_replica_sets", "configures replica set"

attribute "mongo/replSet", 
  :display_name => "Mongo Replica Set Name",
  :description => "Mongo Replica Set Name",
  :required => "optional"
