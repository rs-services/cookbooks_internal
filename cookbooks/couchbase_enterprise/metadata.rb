maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures couchbase""
version          "0.0.1"

depends 'rs_utils'
depends 'sys_firewall'
depends 'sys_dns'
depends "block_device"

recipe "couchbase::default", "installs couchbase"
recipe "couchbase::do_storage_restore", "restores volume restarts couchbase"
recipe "couchbase::do_storage_create", "creates volume, and sets up couchbase on the volume"
recipe "couchbase::do_storage_backup", "backs up couchbase volumes"
recipe "couchbase::do_primary_backup_schedule_enable", "enables random cron for do_storage_backup"
recipe "couchbase::do_primary_backup_schedule_disable", "disables cron for do_storage_backup"

#{node[:cb][:install_dir]}
#attribute "couchbase/replication/server_type", 
#  :display_name => "Solr Server Type (Master, Slave)",
#  :description => "Specify the server type (master or slave) for the Solr server.",
#  :required => "optional",
#  :choice => ["master","slave"],
#  :default => "master",
#  :recipes => [ "couchbase::replication" ]

