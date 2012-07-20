maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Install and Configure Apache Hadoop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends 'rightscale'
depends "block_device"
depends "sys_firewall"
depends "sys_dns"

recipe 'hadoop::default', "Install, configure and init hadoop"
recipe 'hadoop::install', 'Install hadoop'
recipe 'hadoop::do_config', 'Configure hadoop'
recipe 'hadoop::do_init', 'Format the namenode'
recipe "hadoop::do_start", "Start Hadoop"
recipe "hadoop::do_stop", "Stop Hadoop"
recipe "hadoop::do_restart", "Restart Hadoop"
recipe "hadoop::do_attach_request", "Attach request"
recipe "hadoop::handle_attach", "Handle Attach"
recipe "hadoop::do_attach_all", "Handle Attach All"
recipe "hadoop::do_detach_request", "Detach request"
recipe "hadoop::handle_detach", "Handle Detach"
recipe "hadoop::do_detach_all", "Handle Detach All"
recipe "hadoop::do_allow", "Allow connections between cluster hosts"
recipe "hadoop::do_disallow", "Disallow connections between cluster hosts"

attribute "ssh/public_ssh_key",
  :display_name => "public ssh key ",
  :description => "Hadoop needs a public ssh key which it can use to ssh to 
systems in it's cluster. This key should also match the private key supplied in ssh/private_ssh_key",
  :required => "required",
  :recipes => [ "hadoop::do_init" ]

attribute "hadoop/node/type",
  :display_name => "Hadoop node type",
  :description => "Hadoop node type, used for managing slaves and masters",
  :choice => ['namenode','datanode','tasktracker', 'jobtracker'],
  :default=>'namenode',
  :type => "string",
  :recipes => [  "hadoop::default","hadoop::do_init","hadoop::do_config" ]

attribute "hadoop/dfs/replication",
  :display_name => "Hadoop namenode dfs.replicaton property ",
  :description => "Hadoop namenode dfs.replicaton property",
  :type => "string",
  :required => "optional",
  :recipes => [ "hadoop::do_config" ]

attribute "hadoop/namenode/address/port",
  :display_name => "Namenode firewall port",
  :description => "Set the firewall port used by the namenode",
  :type => "string",
  :default =>"8020",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/namenode/http/port",
  :display_name => "Namenode http firewall port",
  :description => "Set the firewall port used by the namenode http server",
  :type => "string",
  :default =>"50070",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/address/port",
  :display_name => "Datanode address firewall port",
  :description => "Set the firewall port used by the datanode address",
  :type => "string",
  :default =>"50010",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/ipc/port",
  :display_name => "Datanode ipc firewall port ",
  :description => "Set the firewall port used by the datanode ipc address",
  :type => "string",
  :default =>"50020",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/http/port",
  :display_name => "Datanode http firewall port ",
  :description => "Set the firewall port used by the datanode http server",
  :type => "string",
  :default =>"50075",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

