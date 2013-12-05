maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Provides the Percona implementation of the 'db' resource to" +
                 " install and manage Percona database stand-alone servers and clients."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "13.5.24"

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

attribute "db_percona/init_timeout",
  :display_name => "Percona Init Timeout",
  :description =>
    "Defines timeout to wait for a Percona socket connection. Default: 600",
  :required => "optional",
  :default => "600",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/expire_logs_days",
  :display_name => "Percona Expire Logs Days",
  :description =>
    "Defines number of days to wait until the log expires. Default: 2",
  :required => "optional",
  :default => "2",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/enable_percona_upgrade",
  :display_name => "Enable percona_upgrade",
  :description =>
    "Run percona_upgrade if a restore from an older version of Percona" +
    " is detected. Default: false",
  :required => "optional",
  :choice => ["true", "false"],
  :default => "false",
  :recipes => ["db_percona::setup_server_5_5"]

attribute "db_percona/compressed_protocol",
  :display_name => "Compression of the slave/master protocol",
  :description =>
    "Use compression of the slave/master protocol if both the slave and the" +
    " master support it. Default: disabled",
  :required => "optional",
  :choice => ["enabled", "disabled"],
  :default => "disabled",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/ssl/ca_certificate",
  :display_name => "CA SSL Certificate",
  :description =>
    "The name of your CA SSL Certificate." +
    " This is one of the 5 inputs needed to do secured replication." +
    " Example: cred:CA_CERT. Please DO NOT use this input for LAMP" +
    " ServerTemplates.",
  :required => "optional",
  :default => "",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/ssl/master_certificate",
  :display_name => "Master SSL Certificate",
  :description =>
    "The name of your Master SSL Certificate." +
    " This is one of the 5 inputs needed to do secured replication." +
    " Example: cred:MASTER_CERT. Please DO NOT use this input for LAMP" +
    " ServerTemplates.",
  :required => "optional",
  :default => "",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/ssl/master_key",
  :display_name => "Master SSL Key",
  :description =>
    "The name of your Master SSL Key." +
    " This is one of the 5 inputs needed to do secured replication." +
    " Example: cred:MASTER_KEY. Please DO NOT use this input for LAMP" +
    " ServerTemplates.",
  :required => "optional",
  :default => "",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/ssl/slave_certificate",
  :display_name => "Slave SSL Certificate",
  :description =>
    "The name of your Slave SSL Certificate." +
    " This is one of the 5 inputs needed to do secured replication." +
    " Example: cred:SLAVE_CERT. Please DO NOT use this input for LAMP" +
    " ServerTemplates.",
  :required => "optional",
  :default => "",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]

attribute "db_percona/ssl/slave_key",
  :display_name => "Slave SSL Key",
  :description =>
    "The name of your Slave SSL Key." +
    " This is one of the 5 inputs needed to do secured replication." +
    " Example: cred:SLAVE_KEY. Please DO NOT use this input for LAMP" +
    " ServerTemplates.",
  :required => "optional",
  :default => "",
  :recipes => [
    "db_percona::setup_server_5_5"
  ]
