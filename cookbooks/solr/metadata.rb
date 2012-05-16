maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rs_utils'
depends 'app_tomcat'
depends 'sys_firewall'
depends 'sys_dns'

recipe "solr::default", "installs solr"
recipe "solr::install_example_app", "installs solr example app"
recipe "solr::configure_solr_and_solrconfig", "configures solr.xml and solrconfig.xml" 
recipe "solr::replication", "configures replication"
recipe "solr::setup_redirect_page", "sets up redirect page for port 80"

attribute "solr/storage_type", 
  :display_name => "Solr Storage Location", 
  :description => "Location of solr files, either ephemeral or storage(ebs)", 
  :required => "optional", 
  :choice => ["storage1", "ephemeral", "storage2"],
  :default => "storage1"

attribute "solr/replication/server_type", 
  :display_name => "Solr Server Type(Master, Slave)",
  :description => "Solr Server Type(Master, Slave)",
  :required => "optional",
  :choice => ["master","slave"],
  :default => "master"

attribute "solr/replication/master", 
  :display_name => "Solr Master Host", 
  :description => "Hostname of Solr Master", 
  :required => "optional", 
  :default => "localhost"

attribute "solr/replication/files_to_replicate",
  :display_name => "Solr Files to replicate", 
  :description => "Solr Config Files to Replicate", 
  :required => "optional",
  :default => "schema.xml,stopwords.txt,elevate.xml"

attribute "solr/replication/slave_poll_interval",
  :display_name => "Solr Slave Poll Interval", 
  :description => "Interval in which the slave should poll master .Format is HH:mm:ss",
  :required => "optional", 
  :default => "00:00:20"

attribute "solr/replication/master_dns_id",
  :display_name => "Solr Master DNS ID",
  :description => "Solr Master DNS ID", 
  :required => "required"

attribute "solr/replication/slave_dns_id",
  :display_name => "Solr Slave DNS ID",
  :description => "Solr Slave DNS ID", 
  :required => "optional"
# optional attributes, no necessary for solr to start
attribute "tomcat/db_name",
  :display_name => "Database Name",
  :description => "Enter the name of the MySQL database to use. Ex: mydatabase",
  :required => "optional",
  :default => "none"
