maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Provides the Percona implementation of the 'db' resource to" +
                 " install and manage Percona database stand-alone servers and clients."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "13.5.20"

supports "centos"
supports "redhat"
supports "ubuntu"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"

recipe "db_percona::setup_server_5_5",
  "Sets the DB Percona provider. Sets version 5.5 and node variables specific" +
  " to Percona 5.5."
recipe "db_percona::setup_repos",
  "Add the percona repository"

attribute "db_percona",
  :display_name => "General Database Options",
  :type => "hash"

# == Default server attributes
#
attribute "db_percona/server_usage",
  :display_name => "Server Usage",
  :description =>
    "When set to 'dedicated' all server resources are allocated to Percona." +
    " When set to 'shared' less resources are allocated for Percona" +
    " so that it can be run concurrently with other" +
    " apps like Apache and Rails for example. Example: shared",
  :choice => ["shared", "dedicated"],
  :required => "optional",
  :default => "shared",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/log_bin",
  :display_name => "Percona Binlog Destination",
  :description =>
    "Defines the filename and location of your Percona stored binlog files." +
    " Sets the 'log-bin' variable in the Percona config file." +
    " Example: /mnt/percona-binlogs/percona-bin",
  :required => "optional",
  :default => "/mnt/ephemeral/percona-binlogs/percona-bin",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/tunable/innodb_log_file_size",
  :display_name => "Percona InnoDB Log Size",
  :description =>
    "Defines the mysql innodb_log_file_size my.cnf parameter"+
    " Example: 512M",
  :required => "optional",
  :default => "64M",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/binlog_format",
  :display_name => "Percona Binlog Format",
  :description =>
    "Defines the format of your Percona stored binlog files." +
    " Sets the 'binlog_format' option in the Percona config file." +
    " Accepted options: STATEMENT, ROW, and MIXED. Example: MIXED",
  :required => "optional",
  :choice => ["STATEMENT", "ROW", "MIXED"],
  :default => "MIXED",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/tmpdir",
  :display_name => "Percona Temp Directory Destination",
  :description =>
    "Defines the location of your Percona temp directory." +
    " Sets the 'tmpdir' variable in the Percona config file. Example: /tmp",
  :required => "optional",
  :default => "/mnt/ephemeral/perconatmp",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]
