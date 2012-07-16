maintainer       "RightScale Inc"
maintainer_email "ps@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures oracle"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "oracle::download_oracle", "Downloads oracle from s3 with aria2c"
recipe "oracle::install_oracle", "installs oracle 11G and dependencies"
recipe "oracle::setup_swap", "configures swap of 100% of ram"
recipe "oracle::backup_oracle_using_expdp", "backs up the db using expdp"
recipe "oracle::restore_oracle_using_impdp", "restores db using impdp"
recipe "oracle::install_local_and_sandbox_oci8_rubygem_on_server", "installs ruby oci-8 on the oracle db server"
recipe "oracle::open_oracle_port", "Oracle port 1521 to the world"
recipe "oracle::add_backup_to_cron", "add the backup script to cron at a random interval, once per hour"
recipe "oracle::add_audit_user", "add_audit_user"
recipe "oracle::tune_oracle_memory", "tunes oracle memory to 60% of available ram"
recipe "oracle::install_oracle_client", "installs oracle client"

depends "rightscale"
depends "bootstrap"
depends "sysctl"
depends "block_device"

attribute "oracle/starterdb/password/all", 
  :display_name => "Starterdb ALL Password",
  :description => "The ALL password for the starter db \n  Oracle recommends that the ADMIN password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9]",
  :required => "optional",
  :recipes => [ "oracle::install_oracle" ]

attribute "oracle/starterdb/password/sys",
  :display_name => "Starterdb SYS Password",
  :description => "The SYS password for the starter db",
  :required => "optional",
  :recipes => [ "oracle::install_oracle" ]

attribute "oracle/starterdb/password/system",
  :display_name => "Starterdb SYSTEM Password",
  :description => "The SYSTEM password for the starter db",
  :required => "optional",
  :recipes => [ "oracle::install_oracle","restore_oracle_using_expdp" ]

attribute "oracle/starterdb/password/sysman",
  :display_name => "Starterdb SYSMAN Password",
  :description => "The SYSMAN password for the starter db",
  :required => "optional",
  :recipes => [ "oracle::install_oracle" ]

attribute "oracle/starterdb/password/dbsnmp",
  :display_name => "Starterdb DBSNMP Password",
  :description => "The DBSNMP password for the starter db",
  :required => "optional",
  :recipes => [ "oracle::install_oracle" ]

attribute "oracle/install_file1_url", 
  :display_name => "Oracle Install ZipFile 1",
  :description => "Url to the oracle zip file", 
  :required => "optional", 
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_1of2.zip",
  :recipes => [ "oracle::download_oracle" ]

attribute "oracle/install_file2_url",
  :display_name => "Oracle Install ZipFile 2",
  :description => "Url to the oracle zip file",
  :required => "optional",
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_2of2.zip",
  :recipes => [ "oracle::download_oracle" ]

attribute "amazon/access_key_id",
  :display_name => "Amazon Access Key",
  :description => "Amazon Access Key",
  :recipes => [ "oracle::backup_oracle_using_expdp","oracle::restore_oracle_using_impdp" ],
  :required => "required"

attribute "amazon/secret_access_key",
  :display_name => "Amazon Secret Access Key",
  :description => "Amazon Secret Access Key",
  :recipes => [ "oracle::backup_oracle_using_expdp","oracle::restore_oracle_using_impdp" ],
  :required => "required"

attribute "oracle/backup/bucket",
  :display_name => "amazon s3 bucket for backups",
  :description => "amazon s3 bucket for db backups", 
  :recipes => [ "oracle::backup_oracle_using_expdp","oracle::restore_oracle_using_impdp" ],
  :required => "required"

attribute "oracle/backup/backup_prefix",
    :display_name => "backup prefix for backups",
    :description => "backup prefix for db backups, ex mydb",
    :recipes => [ "oracle::backup_oracle_using_expdp","oracle::restore_oracle_using_impdp" ],
    :required => "required"

attribute "oracle/backup/restore_schemas",
    :display_name => "oracle schemas to restore", 
    :description => "Comma separated list of schemas to restore", 
    :recipes => [ "oracle::backup_oracle_using_expdp","oracle::restore_oracle_using_impdp" ],
    :required => "required"

