maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rs_utils'

recipe "solr::default", "installs solr"
recipe "solr::install_example_app", "installs solr example app"
recipe "solr::configure_solr_and_solrconfig", "configures solr.xml and solrconfig.xml" 
recipe "solr::replication", "configures replication"

attribute "solr/storage_type", 
  :display_name => "Solr Storage Location", 
  :description => "Location of solr files, either ephemeral or storage(ebs)", 
  :required => "optional", 
  :choice => ["storage", "ephemeral"],
  :default => "storage"

attribute "solr/replication/master", 
  :display_name => "Solr Master Host", 
  :description => "Hostname of Solr Master", 
  :required => "optional", 
  :default => "localhost"
