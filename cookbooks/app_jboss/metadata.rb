maintainer       "RightScale Inc."
maintainer_email "ps@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures JBoss"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.2"

depends "rightscale"

recipe "app_jboss::default"                  , "Sets and configures default app provider."
recipe "app_jboss::install"                  , "Installs and configures JBoss."
recipe "app_jboss::install_glusterfs_client" , "Installs Glusterfs client libraries."

attribute "app_jboss/tier",
  :description  => "Name of the tier this server belongs to.",
  :recipes      => ["app_jboss::default"],
  :type         => "string",
  :display_name => "tier",
  :required     => "required",
  :choice       => ["standalone-ha", "admin", "batch", "gateway", "ncomportal", "ncomservice"]

# Inputs for: templates/default/standalone-ha.xml.erb


attribute "app_jboss/http_bind_port",
	:description  => "Port for JBoss to accept incoming HTTP connections.",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "http_bind_port",
	:required     => "recommended",
	:default      => "8080"

attribute "app_jboss/https_bind_port",
	:description  => "Port for JBoss to accept incoming HTTPS connections.",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "https_bind_port",
	:required     => "recommended",
	:default      => "8443"

attribute "app_jboss/mysql_connection_url",
  :description  => "MySQL jdbc:// or replication:// type connection url. Separate multiple entries by commas.  Add ?useUnicode=true&amp;characterEncoding=utf8&amp as extra options",
  :recipes      => ["app_jboss::default"],
  :type         => "array",
  :display_name => "mysql_connection_url",
  :required     => "required"

attribute "app_jboss/mysql_user_name",
	:description  => "MySQL Username",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "mysql_user_name",
	:required     => "required"

attribute "app_jboss/mysql_password",
	:description  => "MySQL Password",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "mysql_password",
	:required     => "required"

attribute "app_jboss/virtual_server_name",
  :description  => "Virtualserver DNS name",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "virtual_server_name",
	:required     => "required"

attribute "app_jboss/s3_bucketname",
  :description  => "S3 bucketname for JBoss clustering",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "s3_bucketname",
	:category => "JBOSS CLUSTERING",
	:required     => "required"

attribute "app_jboss/aws_access_key",
  :description  => "AWS_ACCESS_KEY for S3 bucket access
   You need to provide cloud authentication credentials. 
   Use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID). ",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "aws_access_key",
	:category => "JBOSS CLUSTERING",
	:required     => "required"

attribute "app_jboss/aws_secret_access_key",
  :description  => "AWS_SECRET_ACCESS_KEY for S3 bucket access.
   You need to provide cloud authentication credentials. 
   Use your Amazon secret access key ID (e.g., cred:AWS_SECRET_ACCESS_KEY). ",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "aws_secret_access_key",
	:category => "JBOSS CLUSTERING",
	:required     => "required"

attribute "app_jboss/initial_member",
  :description  => "Initial members for cluster",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "initial_member",
	:category => "JBOSS CLUSTERING",
	:required     => "required",
	:default      => "1"

### Inputs for: templates/default/tier_$NAME.sh.erb

attribute "app_jboss/groups_tcp_port",
  :description => "Groups TCP Port",
  :recipes     => ["app_jboss::default"],
  :type        => "string",
  :display     => "app_jboss/groups_tcp_port",
  :required    => "required"

attribute "app_jboss/port",
  :description => "TCP port to listen on",
  :recipes     => ["app_jboss::default"],
  :type        => "string",
  :display     => "app_jboss/port",
  :required    => "required"

attribute "app_jboss/server_name",
  :description => "DNS entry of this appserver",
  :recipes     => ["app_jboss::default"],
  :type        => "string",
  :display     => "app_jboss/server_name",
  :required    => "required"

# Inputs for: templates/default/mgmt-users.properties.erb

attribute "app_jboss/management_user",
	:description  => "Managment UI Username",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "management_user",
	:required     => "required"

attribute "app_jboss/management_password",
	:description  => "Managment UI Password",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "management_password",
	:required     => "required"
