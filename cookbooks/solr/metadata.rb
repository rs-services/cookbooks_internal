maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rs_utils'
recipe "solr::default", "installs solr"

attribute "solr/storage_type", 
  :display_name => "Solr Storage Location", 
  :description => "Location of solr files, either ephemeral or storage(ebs)", 
  :required => "optional", 
  :choice => ["storage", "ephemeral"],
  :default => "storage"
