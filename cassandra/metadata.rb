name             'cassandra'
maintainer       'RightScale Professional Services'
maintainer_email 'ps@rightscale.com'
license          'All rights reserved'
description      'Installs/Configures cassandra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.1'

depends "rightscale"

recipe "cassandra::install", "Downloads Cassandra RPM's and Oracle JRE"
recipe "cassandra::configure", "Configures cassandra.yaml"

attribute "cassandra/cluster_name",
	:description => "Name of the Cassandra cluster",
	:recipes     => ["cassandra::configure"],
	:type        => "string",
	:display     => "cassandra/cluster_name",
	:required    => "required"
