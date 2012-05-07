maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures sphinx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "rs_utils"
depends "sys_firewall"
depends "rightscale_services_tools"

recipe "sphinx::default", "installs and configures sphinx"
recipe "sphinx::install_example_sql", "installs example file, and starts indexer"
recipe "sphinx::configure_and_start_sphinx", "configures and starts sphinx - customer overrides"

attribute "sphinx/db/host",
  :display_name => "Sphinx DB Host",
  :description => "Host to pull sphinx data from", 
  :required => "optional", 
  :recipes => ["sphinx::default"]

attribute "sphinx/db/user",
  :display_name => "Sphinx DB User",
  :description => "Sphinx DB User",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/password",
  :display_name => "Sphinx DB Password",
  :description => "Sphinx DB Password",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/schema",
  :display_name => "Sphinx DB Schema", 
  :description => "Sphinx DB Schema",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/sql_query",
  :display_name => "Sphinx SQL Query", 
  :description => "Main document fetch query. Mandatory, no default value. Applies to SQL source types (mysql, pgsql, mssql) only.",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/sql_attr_uint", 
  :display_name => "Sphinx SQL Attribute(Unsigned Integer)",
  :description => "Unsigned integer attribute declaration. Multi-value (there might be multiple attributes declared), optional. Applies to SQL source types (mysql, pgsql, mssql) only.",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/sql_attr_timestamp",
  :display_name => "Sphinx SQL Attribute(TimeStamp)",
  :description => "UNIX timestamp attribute declaration. Multi-value (there might be multiple attributes declared), optional. Applies to SQL source types (mysql, pgsql, mssql) only.",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/db/sql_query_info", 
  :display_name => "Sphinx SQL Document Query",
  :description => "Document info query. Optional, default is empty. Applies to mysql source type only.",
  :required => "optional",
  :recipes => ["sphinx::default"]

attribute "sphinx/mem_limit", 
  :display_name => "Sphinx Indexer Memory", 
  :description => "Indexing RAM usage limit. Optional, default is 256M",
  :required => "optional",
  :recipes => ["sphinx::default"],
  :default => "256M"

attribute "sphinx/storage_type", 
  :display_name => "Sphinx index Storage Location",
  :required => "optional",
  :choice => ["storage1", "ephemeral", "storage2"],
  :default => "storage1"
