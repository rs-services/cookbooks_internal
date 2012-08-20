maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Install and Configure Apache Hadoop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"


depends 'rightscale'
depends "block_device"
depends "sys_firewall"
depends "sys_dns"
depends "repo"

recipe 'hadoop::default', "Install, configure and init hadoop"
recipe 'hadoop::install', 'Install hadoop'
recipe 'hadoop::do_config', 'Configure hadoop'
recipe 'hadoop::do_init', 'Format the namenode'
recipe "hadoop::do_start", "Start Hadoop"
recipe "hadoop::do_stop", "Stop Hadoop"
recipe "hadoop::do_restart", "Restart Hadoop"
recipe "hadoop::do_attach_request", "Attach request"
recipe "hadoop::handle_attach", "Handle Attach"
recipe "hadoop::do_attach_all", "Handle Attach All"
recipe "hadoop::do_detach_request", "Detach request"
recipe "hadoop::handle_detach", "Handle Detach"
recipe "hadoop::do_detach_all", "Handle Detach All"
recipe "hadoop::do_allow", "Allow connections between cluster hosts"
recipe "hadoop::do_disallow", "Disallow connections between cluster hosts"
recipe "hadoop::do_data_import", "Download data from a cloud provider and copy it into the hadoop FS."
recipe "hadoop::do_map_reduce", "Run MapReduce command.  command and uploads output to cloud provider."


attribute "rightscale/public_ssh_key",
  :display_name => "public ssh key ",
  :description => "Hadoop needs a public ssh key which it can use to ssh to 
systems in it's cluster. This key should also match the private key supplied in ssh/private_ssh_key",
  :required => "required",
  :recipes => [ "hadoop::default", "hadoop::do_init" ]

attribute "hadoop/node/type",
  :display_name => "Hadoop node type",
  :description => "Hadoop node type, used for managing slaves and masters",
  :choice => ['namenode','datanode'],
  :default=>'namenode',
  :type => "string",
  :recipes => [  "hadoop::default","hadoop::do_init","hadoop::do_config" ]

attribute "hadoop/dfs/replication",
  :display_name => "Hadoop namenode dfs.replicaton property ",
  :description => "Hadoop namenode dfs.replicaton property",
  :type => "string",
  :required => "optional",
  :recipes => ["hadoop::default", "hadoop::do_config" ]

attribute "hadoop/namenode/address/port",
  :display_name => "Namenode firewall port",
  :description => "Set the firewall port used by the namenode",
  :type => "string",
  :default =>"8020",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/namenode/http/port",
  :display_name => "Namenode http firewall port",
  :description => "Set the firewall port used by the namenode http server",
  :type => "string",
  :default =>"50070",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/address/port",
  :display_name => "Datanode address firewall port",
  :description => "Set the firewall port used by the datanode address",
  :type => "string",
  :default =>"50010",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/ipc/port",
  :display_name => "Datanode ipc firewall port ",
  :description => "Set the firewall port used by the datanode ipc address",
  :type => "string",
  :default =>"50020",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]

attribute "hadoop/datanode/http/port",
  :display_name => "Datanode http firewall port ",
  :description => "Set the firewall port used by the datanode http server",
  :type => "string",
  :default =>"50075",
  :required => "optional",
  :recipes => [ "hadoop::do_allow","hadooop:do_disallow" ]


attribute "mapreduce/input",
  :display_name => "Hadoop Input Directory",
  :description => "Input directory to copy data",
  :type => "string",
  :default =>"input",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/output",
  :display_name => "Hadoop Output Directory",
  :description => "Output directory to place data after job is done. ",
  :type => "string",
  :default =>"output",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/compile",
  :display_name => "Hadoop mapreduce compile command",
  :description => "Command to compile java code.  Example: javac -classpath 
 /home/hadoop/hadoop-core-1.0.3.jar -d wordcount_classes WordCount.java ",
  :type => "string",
  :default =>"javac -classpath /home/hadoop/hadoop-core-1.0.3.jar -d /mapreduce ClassName.java",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/destination",
  :display_name => "Location of jar file for Hadoop Map Reduce command",
  :description => "Location where data file will be placed.",
  :type => "string",
  :default =>"/mapreduce",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/command",
  :display_name => "Hadoop mapreduce jar command",
  :description => "Hadoop Command to run MapReduce.  Example: bin/hadoop jar 
   /root/mapreduce/wordcount.jar org.myorg.MyMapReduce input output",
  :type => "string",
  :default =>"bin/hadoop jar /mapreduce/wordcount.jar org.myorg.ClassName input output",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/name",
  :display_name => "Hadoop mapreduce program name",
  :description => "Hadoop MapReduce program name.  Example:  MyMapReduce",
  :type => "string",
  :default =>"MyMapReduce",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce" ]

# hadoop data to MapReduce
attribute "mapreduce/data/storage_account_provider",
  :display_name => "Dump Storage Account Provider",
  :description => "Location where the data file will be retrieved from. Used by dump recipes to back up to Amazon S3 or Rackspace Cloud Files.",
  :required => "optional",
  :choice => [ "s3", "cloudfiles", "cloudfilesuk", "SoftLayer_Dallas", "SoftLayer_Singapore", "SoftLayer_Amsterdam" ],
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/storage_account_id",
  :display_name => "Data Storage Account ID",
  :description => "In order to download the data file to the specified cloud storage location, you need to provide cloud authentication credentials. For Amazon S3, use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID). For Rackspace Cloud Files, use your Rackspace login username (e.g., cred:RACKSPACE_USERNAME).",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/storage_account_secret",
  :display_name => "Data Storage Account Secret",
  :description => "In order to get the data file to the specified cloud storage location, you will need to provide cloud authentication credentials. For Amazon S3, use your AWS secret access key (e.g., cred:AWS_SECRET_ACCESS_KEY). For Rackspace Cloud Files, use your Rackspace account API key (e.g., cred:RACKSPACE_AUTH_KEY).",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/container",
  :display_name => "Dump Container",
  :description => "The cloud storage location where the data file will be saved to or restored from. For Amazon S3, use the bucket name. For Rackspace Cloud Files, use the container name.",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/name",
  :display_name => "Data file name to download",
  :description => "The name that will be used to name/locate the data file.  should be a .zip file",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce"]
