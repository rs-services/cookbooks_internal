maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures couchbase"

depends 'rs_utils'
depends 'sys_firewall'
depends 'sys_dns'
depends "block_device"

recipe "couchbase::default", "installs solr"
recipe "couchbase::install_example_app", "installs solr example app"
recipe "couchbase::configure_solr_and_solrconfig", "configures solr.xml and solrconfig.xml" 
recipe "couchbase::replication", "configures replication"
recipe "couchbase::setup_redirect_page", "sets up redirect page for port 80"
recipe "couchbase::install_mysql_connector_in_solr_lib", "installs mysql connector in solr lib dir"
recipe "couchbase::do_storage_restore", "restores volume and restarts tomcat"
recipe "couchbase::do_storage_create", "creates volume, and sets up solr on the volume"
recipe "couchbase::do_storage_backup", "backs up solr volumes"
recipe "couchbase::do_primary_backup_schedule_enable", "enables random cron for do_storage_backup"
recipe "couchbase::do_primary_backup_schedule_disable", "disables cron for do_storage_backup"
