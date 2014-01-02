maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

depends 'rightscale'
depends 'app_tomcat'
depends 'sys_firewall'
depends 'sys_dns'
depends 'web_apache'
depends "block_device"

recipe "solr::default", "installs solr"
recipe "solr::install_example_app", "installs solr example app"
recipe "solr::configure_solr_and_solrconfig", "configures solr.xml and solrconfig.xml" 
recipe "solr::replication", "configures replication"
recipe "solr::setup_redirect_page", "sets up redirect page for port 80"
recipe "solr::install_mysql_connector_in_solr_lib", "installs mysql connector in solr lib dir"
recipe "solr::do_storage_restore", "restores volume and restarts tomcat"
recipe "solr::do_storage_create", "creates volume, and sets up solr on the volume"
recipe "solr::do_storage_backup", "backs up solr volumes"
recipe "solr::do_primary_backup_schedule_enable", "enables random cron for do_storage_backup"
recipe "solr::do_primary_backup_schedule_disable", "disables cron for do_storage_backup"

attribute "solr/replication/server_type", 
  :display_name => "Solr Server Type (Master, Slave)",
  :description => "Specify the server type (master or slave) for the Solr server.",
  :required => "optional",
  :choice => ["master","slave"],
  :default => "master",
  :recipes => [ "solr::replication" ]

attribute "solr/replication/master", 
  :display_name => "Solr Master Host",
  :description => "Hostname of Solr Master.", 
  :required => "optional", 
  :default => "localhost",
  :recipes => [ "solr::replication" ]

attribute "solr/replication/files_to_replicate",
  :display_name => "Solr Files to Replicate", 
  :description => "Solr Config Files to Replicate.", 
  :required => "optional",
  :default => "schema.xml,stopwords.txt,elevate.xml",
  :recipes => [ "solr::replication" ]

attribute "solr/replication/slave_poll_interval",
  :display_name => "Solr Slave Poll Interval", 
  :description => "Interval in which the slave should poll master. Format is HH:MM:SS",
  :required => "optional", 
  :default => "00:00:20",
  :recipes => [ "solr::replication" ]

attribute "solr/replication/master_dns_id",
  :display_name => "Solr Master DNS ID",
  :description => "The unique identifier that is associated with the DNS A record of the master server. The unique identifier is assigned by the DNS provider when you create a dynamic DNS A record. This ID is used to update the associated A record with the private IP address of the master server when this recipe runs.", 
  :required => "required",
  :recipes => [ "solr::replication" ]

attribute "solr/replication/slave_dns_id",
  :display_name => "Solr Slave DNS ID",
  :description => "The unique identifier that is associated with the DNS A record of a slave server. The unique identifier is assigned by the DNS provider when you create a dynamic DNS A record. This ID is used to update the associated A record with the private IP address of a slave server when this recipe runs.", 
  :required => "optional",
  :recipes => [ "solr::replication" ]

attribute "solr/public_hostname", 
  :display_name => "Public Hostname",
  :description => "Public Hostname, used in redirect, can be host or public ip", 
  :required => "required", 
  :recipes => [ "solr::setup_redirect_page" ]

attribute "solr/backup_lineage", 
  :display_name => "Backup Lineage for Solr", 
  :description => "The prefix or container name that will be used to name/locate the primary backup."

attribute "solr/backup_lineage_override",
  :display_name => "Override Backup Lineage for Solr", 
  :description => "The prefix or container name that will be used to name/locate the primary backup."

# optional attribute, not necessary for solr to start
attribute "tomcat/db_name",
  :display_name => "Database Name",
  :description => "Enter the name of the MySQL database to use. Ex: mydatabase",
  :required => "optional",
  :default => "none",
  :recipes => [ "solr::default" ]

#inputs from other cookbooks

#attribute "web_apache/application_name",
#  :display_name => "Application Name",
#  :description => "Sets the directory for your application's web files (/home/webapps/Application Name/current/). If you have multiple applications, you can run the code checkout script multiple times, each with a different value for APPLICATION, so each application will be stored in a unique directory. This must be a valid directory name. Do not use symbols in the name.",
#  :required => "optional",
#  :default => "myapp",
#  :recipes => [ "solr::default" ]
