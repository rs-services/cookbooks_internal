maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Installs/configures a Oracle database client and server."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "12.1.0"

supports "centos", "~> 5.8"
supports "redhat", "~> 5.8"
supports "ubuntu", "~> 10.04.0"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"
depends "aria2"
depends "sysctl"
depends "sys_firewall"

recipe  "db_oracle::default", "Set the DB Oracle provider. Sets version and node variables specific to the chosen MySQL version."
recipe  "db_oracle::install_local_and_sandbox_oci8_rubygem_on_server", "installs ruby oci-8 on the oracle db server"
recipe  "db_oracle::register_master" , "Register master database server with DNS service"
recipe  "db_oracle::provider_test", "Tests Resources and Providers"

attribute "db_oracle",
  :display_name => "General Database Options",
  :type => "hash"

# == Default attributes
#
attribute "oracle/install_file1_url", 
  :display_name => "Oracle Install ZipFile 1",
  :description => "Url to the oracle zip file", 
  :required => "optional", 
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_1of2.zip",
  :recipes => [ "db_oracle::default" ]

attribute "oracle/install_file2_url",
  :display_name => "Oracle Install ZipFile 2",
  :description => "Url to the oracle zip file",
  :required => "optional",
  :default => "http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_database_2of2.zip",
  :recipes => [ "db_oracle::default" ]

attribute "db/sys/password",
  :display_name => "Oracle SYS Password",
  :description => "The SYS password for the starter db",
  :required => "required",
  :recipes => [ "db_oracle::default" ]

attribute "db/system/password",
  :display_name => "Oracle SYSTEM Password",
  :description => "The SYSTEM password for the starter db",
  :required => "required",
  :recipes => [ "db_oracle::default","restore_oracle_using_expdp" ]

attribute "db/sysman/password",
  :display_name => "Oracle SYSMAN Password",
  :description => "The SYSMAN password for the starter db",
  :required => "required",
  :recipes => [ "db_oracle::default" ]

attribute "db/dbsnmp/password",
  :display_name => "Oracle DBSNMP Password",
  :description => "The DBSNMP password for the starter db",
  :required => "required",
  :recipes => [ "db_oracle::default" ]

attribute "db/dns/master/id",
  :display_name => "Database Master DNS Record ID",
  :description => "The unique identifier that is associated with the DNS A record 
of the master database server. The unique identifier is assigned by the DNS provider 
when you create a dynamic DNS A record. This ID is used to update the associated 
A record with the private IP address of the master server when this recipe is run. 
If you are using DNS Made Easy as your DNS provider, a 7-digit number is used 
(e.g., 4403234).",
  :required => "optional",
  :recipes => [ "db_oracle::register_master" ]
