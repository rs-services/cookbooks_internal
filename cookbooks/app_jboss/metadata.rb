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
  :choice       => ["admin", "batch", "gateway", "ncomportal", "ncomservice"]

attribute "app_jboss/bind_address",
	:description  => "Address for JBoss to bind to.",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "bind_address",
	:required     => "recommended",
	:default      => "127.0.0.1"

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

attribute "app_jboss/dbapplication_username",
	:description  => "MySQL Username",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "dbapplication_username",
	:required     => "required"

attribute "app_jboss/dbapplication_password",
	:description  => "MySQL Password",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "dbapplication_password",
	:required     => "required"


attribute "app_jboss/master_db_dnsname",
	:description  => "MySQL Database DNS Name",
	:recipes      => ["app_jboss::default"],
	:type         => "string",
	:display_name => "master_db_dnsname",
	:required     => "required"

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


=begin
attribute "app_jboss/java_opts",
	:description  => "Java Options",
	:recipes      => ["app_jboss::install", "app_jboss::setup_monitoring"],
	:type         => "string",
	:display_name => "java_opts",
	:required     => "recommended",
	:default      => "-Xms128m -Xmx512m -XX:MaxPermSize=256m -Dorg.jboss.resolver.warning=true -Dsun.rmi.dgc.client.gcInterval=3600000 -Dsun.rmi.dgc.server.gcInterval=3600000"
=end
