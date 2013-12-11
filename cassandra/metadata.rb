name             'cassandra'
maintainer       'RightScale Professional Services'
maintainer_email 'ps@rightscale.com'
license          'All rights reserved'
description      'Installs/Configures cassandra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.1'

depends "rightscale"

recipe "cassandra::install", "Downloads Cassandra RPM's and Oracle JRE"
recipe "cassandra::configure", "Configures cassandra.yaml and starts the service"

attribute "cassandra/cluster_name",
	:description => "Name of the Cassandra cluster",
	:recipes     => ["cassandra::configure"],
	:type        => "string",
	:display     => "cassandra/cluster_name",
	:required    => "required"

attribute "cassandra/snitch",
  :description => "Cassandra snitch to use. See: http://www.datastax.com/documentation/cassandra/2.0/mobile/cassandra/architecture/architectureSnitchesAbout_c.html",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :display     => "cassandra/snitch",
  :choice      => ["SimpleSnitch", "Ec2Snitch", "Ec2MultiRegionSnitch"],
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