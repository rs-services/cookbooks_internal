maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Install and Configure Apache Hadoop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends 'rs_utils'
depends "block_device"
depends "sys_firewall"
depends "sys_dns"

recipe 'hadoop::install', 'Install hadoop'
recipe 'hadoop::do_config', 'Configure hadoop'
recipe 'hadoop::do_init', 'Creates formats the namenode'
recipe "hadoop::do_start", "Start Hadoop"
recipe "hadoop::do_stop", "Stop Hadoop"
recipe "hadoop::do_restart", "Restart Hadoop"
recipe "hadoop::do_attach_request", "Attach request"
recipe "hadoop::handle_attach", "Handle Attach"
recipe "hadoop::do_attach_all", "Handle Attach All"
recipe "hadoop::do_detach_request", "Detach request"
recipe "hadoop::handle_detach", "Handle Detach"
recipe "hadoop::do_detach_all", "Handle Detach All"

attribute "hadoop/node/type",
  :display_name => "Hadoop node type",
  :description => "Hadoop node type, used for managing slaves and masters",
  :choice => ['namenode','datanode','tasktracker', 'jobtracker'],
  :default=>'namenode',
  :type => "string",
  :recipes => [ "hadoop::do_init","hadoop::do_config" ]

attribute "hadoop/dns/namenode/fqdn",
  :display_name => "Hadoop namenode hostname ",
  :description => "FQDN of the NameNode",
  :type => "string",
  :required => "required",
  :recipes => [ "hadoop::do_init","hadoop::do_config" ]


attribute "hadoop/dns/namenode/id",
  :display_name => "Hadoop Host Id ",
  :description => "DNS Service ID for namenode",
  :type => "string",
  :required => "optional",
  :recipes => [ "hadoop::do_init" ]

attribute "hadoop/dfs/replication",
  :display_name => "Hadoop namenode dfs.replicaton property ",
  :description => "Hadoop namenode dfs.replicaton property",
  :type => "string",
  :required => "optional",
  :recipes => [ "hadoop::do_config" ]



