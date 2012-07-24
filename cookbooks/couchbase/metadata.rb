maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved, parts Copyright Couchbase, Inc. Copyright RightScale, Inc. All rights reserved."
description      "Installs/Configures couchbase"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.3"

depends "rightscale"
depends 'sys_firewall'
depends 'sys_dns'
depends "block_device"

recipe "couchbase::default", "Sets tags"
recipe "couchbase::install_couchbase", "installs couchbase package, no configuration"
recipe "couchbase::bucket_create", "sets up cb buckets"
recipe "couchbase::init_cluster", "Run to init a new cb cluster, sets cluster_ip tag"
recipe "couchbase::join_cluster", "Run on instance to join a cb cluster using the cluster_ip tag"
recipe "couchbase::do_storage_restore", "restores volume and restarts tomcat"
recipe "couchbase::do_storage_create", "creates volume, and sets up couchbase on the volume"
recipe "couchbase::do_storage_backup", "backs up couchbase volumes"
recipe "couchbase::do_primary_backup_schedule_enable", "enables random cron for do_storage_backup"
recipe "couchbase::do_primary_backup_schedule_disable", "disables cron for do_storage_backup"
recipe "couchbase::setup_or_restore", "runs setup or restore of block device"
recipe "couchbase::start_server", "starts couchbase server"
recipe "couchbase::stop_server", "stops couchbase server"

# Required Input #
attribute "couchbase/initial_launch",
   :display_name => "Couchbase INITIAL Launch?",
   :description => "Specify TRUE or FALSE (create block device, or restore)",
   :required => "optional",
   :type => "string",
   :choice => ['TRUE', 'FALSE'],
   :default => 'TRUE',
   :recipes => ["couchbase::setup_or_restore"]

attribute "db_couchbase/cluster/username",
      :description => "Cluster REST/Web Administrator Username",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "Administrator",
      :display_name => "Cluster REST/Web Username",
      :required => "optional"

attribute "db_couchbase/cluster/password",
      :description => "Cluster REST/Web Administrator Password",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default =>  "password",
      :display_name => "Cluster REST/Web Password",
      :required => "optional"

attribute "db_couchbase/cluster/tag",
      :description => "Cluster Tag used to auto-join nodes of the same tag, when non-empty",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "",
      :display_name => "Cluster Tag",
      :required => "optional"

attribute "db_couchbase/bucket/name",
      :description => "Bucket Name",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "default",
      :display_name => "Bucket Name",
      :required => "optional"

attribute "db_couchbase/bucket/password",
      :description => "Bucket Password",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "",
      :display_name => "Bucket Password",
      :required => "optional"

attribute "db_couchbase/bucket/ram",
      :description => "Bucket RAM Quota in MB",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "2000",
      :display_name => "Bucket RAM Quota",
      :required => "optional"

attribute "db_couchbase/bucket/replica",
      :description => "Bucket Replica Count",
      :recipes => [ "couchbase::default" ],
      :type => "string",
      :default => "1",
      :display_name => "Bucket Replica Count",
      :required => "optional"

