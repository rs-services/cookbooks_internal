maintainer       "RightScale Inc."
maintainer_email "ps@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures cassandra"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version 					"1.2.1"

depends "rightscale"

recipe "cassandra::install"   , "Add the Apache Cassandra repo and install software."
recipe "cassandra::configure" , "Install Cassandra config files from Chef templates."

#### Required inputs ####

attribute "cassandra/version",
  :description  => "Version string of Cassandra to install.",
  :recipes      => ["cassandra::install"],
  :type         => "string",
  :display_name => "version",
  :required     => "recommended",
  :default      => "1.2.3"

attribute "cassandra/cluster_name",
  :description  => "Name of the Cassandra cluster.",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "cluster_name",
  :required     => "required"

attribute "cassandra/seeds",
  :description  => "Comma seperated list of seed hosts",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "seeds",
  :required     => "recommended"

attribute "cassandra/num_tokens",
  :description  => "Number of tokens assigned to this node",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "num_tokens",
  :required     => "recommended",
  :default      => "256"

attribute "cassandra/data_file_directories",
  :description  => "Directories where Cassandra should store data on disk.",
  :recipes      => ["cassandra::install", "cassandra::configure"],
  :type         => "array",
  :display_name => "data_file_directories",
  :required     => "recommended",
  :default      => "/mnt/ephemeral/cassandra/data"

attribute "cassandra/commitlog_directory",
  :description  => "Directory where commit logs will be written to.",
  :recipes      => ["cassandra::install",  "cassandra::configure"],
  :type         => "string",
  :display_name => "commitlog_directory",
  :required     => "recommended",
  :default      => "/mnt/ephemeral/cassandra/commitlog"

attribute "cassandra/saved_caches_directory",
  :description  => "Directory where saved caches will be written to.",
  :recipes      => ["cassandra::install", "cassandra::configure"],
  :type         => "string",
  :display_name => "saved_caches_directory",
  :required     => "recommended",
  :default      => "/mnt/ephemeral/cassandra/saved_caches"

attribute "cassandra/log4j_directory",
  :description  => "Directory where the main logfile will be written to",
  :recipes      => ["cassandra::install"],
  :type         => "string",
  :display_name => "log4j_directory",
  :required     => "recommended",
  :default      => "/mnt/ephemeral/cassandra/logs"
