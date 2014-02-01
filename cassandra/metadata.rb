name             'cassandra'
maintainer       'RightScale Professional Services'
maintainer_email 'ps@rightscale.com'
license          'All rights reserved'
description      'Installs/Configures cassandra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.2.6'

depends "rightscale"

recipe "cassandra::install", "Downloads Cassandra RPM's and Oracle JRE"
recipe "cassandra::configure", "Configures cassandra.yaml and starts the service"

attribute "cassandra/cluster_name",
	:description => "Name of the Cassandra cluster",
	:recipes     => ["cassandra::configure"],
	:type        => "string",
	:display     => "cassandra/cluster_name",
	:required    => "required"

attribute "cassandra/is_seed_host",
  :description => "Is this host going to be a seed host?",
  :recipes     => ["cassandra::install"],
  :type        => "string",
  :display     => "cassandra/is_seed_host",
  :choice      => ["true", "false"],
  :default     => "false",
  :required    => "recommended"

attribute "cassandra/snitch",
  :description => "Cassandra snitch to use. See: http://www.datastax.com/documentation/cassandra/2.0/mobile/cassandra/architecture/architectureSnitchesAbout_c.html",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/snitch",
  :choice      => ["SimpleSnitch", "Ec2Snitch", "Ec2MultiRegionSnitch", "GossipingPropertyFileSnitch"],
  :default     => "Ec2Snitch",
  :required    => "recommended"
  
attribute "cassandra/commitlog_directory",
  :description => "Directory where Cassandra commitlogs are stored",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/commitlog_directory",
  :required    => "recommended",
  :default     => "/mnt/ephemeral/cassandra/commitlog"

attribute "cassandra/data_file_directories",
  :description => "Comma separated list of directories where Cassandra data files should be stored",
  :recipes     => ["cassandra::configure"],
  :type        => "array",
  :display     => "cassandra/data_file_directories",
  :required    => "recommended",
  :default     => "/mnt/ephemeral/cassandra/data"

attribute "cassandra/saved_caches_directory",
  :description => "Directory where Cassandra saved caches are stored",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/saved_caches_directory",
  :required    => "recommended",
  :default     => "/mnt/ephemeral/cassandra/saved_caches"

attribute "cassandra/require_inter_node_encryption",
  :description => "Enable encryption between Cassandra nodes?",
  :recipe      => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/require_inter_node_encryption",
  :choice      => ["true", "false"],
  :required    => "recommended",
  :default     => "false"

attribute "cassandra/encryption_password",
  :description => "The password to be used for the keystore and truststore files",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/encryption_password",
  :required    => "recommended"

attribute "cassandra/authenticator",
  :description => "Cassandra authentication backend",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/authenticator",
  :choice      => ["AllowAllAuthenticator", "PasswordAuthenticator"],
  :required    => "recommended",
  :default     => "AllowAllAuthenticator"

attribute "cassandra/authorizer",
  :description => "Cassandra authorizer",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/authorizer",
  :choice      => ["AllowAllAuthorizer", "CassandraAuthorizer"],
  :required    => "recommended",
  :default     => "AllowAllAuthorizer"

attribute "cassandra/bucket",
  :description => "S3 / Cloudfiles bucket where truststore / keystore are located",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/bucket",
  :required    => "recommended"

attribute "cassandra/provider",
  :description => "File storage provider where truststore / keystore are located (if using encryption, otherwise ignore)",
  :recipes => ["cassandra::configure"],
  :type => "string",
  :display => "cassandra/provider",
  :choice => ["S3", "cloudfiles"]

attribute "cassandra/storage_account_id",
  :description => "Access key ID of storage provider",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/storage_account_id",
  :required    => "recommended"

attribute "cassandra/storage_account_secret",
  :description => "Secret key ID of storage provider",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/storage_account_secret",
  :required    => "recommended"

attribute "cassandra/truststore",
  :description => "Location of truststore in bucket (if using encryption see documentation for creating this file).",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/truststore_url",
  :required    => "recommended"

attribute "cassandra/keystore",
  :description => "Location of keystore in bucket (if using encryption see documentation for creating this file).",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/keystore_url",
  :required    => "recommended"

