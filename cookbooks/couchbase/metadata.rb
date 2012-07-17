maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures couchbase"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rs_utils'
depends 'sys_firewall'
depends 'sys_dns'
depends "block_device"

recipe "couchbase::default", "installs couchbase"
recipe "couchbase::install_example_app", "installs couchbase example app"
recipe "couchbase::replication", "configures replication"
recipe "couchbase::setup_redirect_page", "sets up redirect page for port 80"
recipe "couchbase::do_storage_restore", "restores volume and restarts tomcat"
recipe "couchbase::do_storage_create", "creates volume, and sets up couchbase on the volume"
recipe "couchbase::do_storage_backup", "backs up couchbase volumes"
recipe "couchbase::do_primary_backup_schedule_enable", "enables random cron for do_storage_backup"
recipe "couchbase::do_primary_backup_schedule_disable", "disables cron for do_storage_backup"
recipe "couchbase::setup_or_restore", "runs setup or restore of block device"

# Required Input #
attribute "couchbase/initial_launch",
   :display_name => "Couchbase INITIAL_RUN?",
   :description => "Specify TRUE or FALSE (create block device, or restore)",
   :required => "optional",
   :type => "string",
   :choice => ['TRUE', 'FALSE'],
   :default => 'TRUE',
   :recipes => ["couchbase::setup_or_restore"]

