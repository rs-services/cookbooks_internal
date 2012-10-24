maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Install and Configure Apache Hadoop"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"


depends 'rightscale'
depends "block_device"
depends "sys_firewall"
depends "sys_dns"
depends "repo"
depends "bootstrap"

recipe 'hadoop::default', "Install, configure and initialize Hadoop"
recipe 'hadoop::install', 'Install Hadoop'
recipe 'hadoop::do_config', 'Configure Hadoop'
recipe 'hadoop::do_init', 'Format the namenode'
recipe "hadoop::do_start", "Start Hadoop"
recipe "hadoop::do_stop", "Stop Hadoop"
recipe "hadoop::do_restart", "Restart Hadoop"
recipe "hadoop::do_attach_request", "Attach datanodes to the namenode during boot."
recipe "hadoop::handle_attach", "Handle Attach"
recipe "hadoop::do_attach_all", "Attach datanodes to the namenode run from cron on the namenode"
recipe "hadoop::do_detach_request", "Detach datanodes from the namenode when terminating the server."
recipe "hadoop::handle_detach", "Handle Detach"
recipe "hadoop::do_detach_all", "Detach datanodes from the namenode.  Runs from cron on the namenode"
recipe "hadoop::do_allow", "Add firewall rules to allow namenode and datanode connections within the cluster"
recipe "hadoop::do_deny", "Remove firewall rules for nodenames and datanodes. "
recipe "hadoop::do_data_import", "Run on Namenode. Download data from a cloud provider ROS and copy it into the Hadoop HDFS."
recipe "hadoop::do_map_reduce", "Run on Namenode, Run MapReduce command on data imported and upload it to the cloud provider ROS."
recipe "hadoop::do_cleanup", "Run on Namenode. Remove working directories and MapReduce input/output directories"


attribute "rightscale/public_ssh_key",
  :display_name => "Public SSH Key ",
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
  :recipes => [  "hadoop::default","hadoop::do_init","hadoop::do_config","hadoop::do_data_import", "hadoop::do_cleanup" ]

attribute "hadoop/dfs/replication",
  :display_name => "Hadoop namenode dfs.replicaton property ",
  :description => "Hadoop namenode dfs.replicaton property",
  :type => "string",
  :required => "required",
  :recipes => ["hadoop::default", "hadoop::do_config" ]

attribute "hadoop/namenode/address/port",
  :display_name => "Namenode firewall port",
  :description => "Set the firewall port used by the namenode",
  :type => "string",
  :default =>"8020",
  :recipes => [ "hadoop::do_allow","hadooop:do_deny" ]

attribute "hadoop/namenode/http/port",
  :display_name => "Namenode http firewall port",
  :description => "Set the firewall port used by the namenode http server",
  :type => "string",
  :default =>"50070",
  :recipes => [ "hadoop::do_allow","hadooop:do_deny" ]

attribute "hadoop/datanode/address/port",
  :display_name => "Datanode address firewall port",
  :description => "Set the firewall port used by the datanode address",
  :type => "string",
  :default =>"50010",
  :recipes => [ "hadoop::do_allow","hadooop:do_deny" ]

attribute "hadoop/datanode/ipc/port",
  :display_name => "Datanode ipc firewall port ",
  :description => "Set the firewall port used by the datanode ipc address",
  :type => "string",
  :default =>"50020",
  :recipes => [ "hadoop::do_allow","hadooop:do_deny" ]

attribute "hadoop/datanode/http/port",
  :display_name => "Datanode http firewall port ",
  :description => "Set the firewall port used by the datanode http server",
  :type => "string",
  :default =>"50075",
  :recipes => [ "hadoop::do_allow","hadooop:do_deny" ]


attribute "mapreduce/input",
  :display_name => "Hadoop HDFS Input Directory",
  :description => "Directory created in HDFS for input data used by MapReduce command",
  :type => "string",
  :default =>"input",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import" ]

attribute "mapreduce/output",
  :display_name => "Hadoop HDFS Output Directory",
  :description => "Output directory to place data when MapReduce command is run. ",
  :type => "string",
  :default =>"output",
  :required => "optional",
  :recipes => [ "hadoop::do_map_reduce" ]

attribute "mapreduce/compile",
  :display_name => "Hadoop MapReduce source files to compile.",
  :description => "Source files to complile. Example: org/myorg/*.java org/myorg/foo/*.java",
  :type => "string",
  :required => "optional",
  :recipes => [ "hadoop::do_map_reduce" ]

attribute "mapreduce/destination",
  :display_name => "Location of all download and compiled files for Hadoop MapReduce command",
  :description => "Location where data file will be placed.",
  :type => "string",
  :default =>"/mapreduce",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/command",
  :display_name => "Hadoop MapReduce class and arguments to run.",
  :description => "The class and arguments to run the MapReduce job.  This input is 
  appended to the end of the 'hadoop jar jarfile' command.  
  Example: org.myorg.MyMapReduce input output",
  :type => "string",
  :required => "optional",
  :recipes => [  "hadoop::do_map_reduce" ]

attribute "mapreduce/name",
  :display_name => "Hadoop MapReduce program name",
  :description => "Used as namespace for paths and commands:  Example MyMapReduce",
  :type => "string",
  :required => "optional",
  :recipes => [ "hadoop::do_map_reduce" ]

# hadoop data to MapReduce
attribute "mapreduce/data/storage_account_provider",
  :display_name => "Data Storage Account Provider",
  :description => "Location where the data file will be imported from and uploaded to. 
   Used by dump recipes to back up to Amazon S3 or Rackspace Cloud Files.",
  :required => "optional",
  :choice => [ "s3", "cloudfiles", "cloudfilesuk", "SoftLayer_Dallas", "SoftLayer_Singapore", "SoftLayer_Amsterdam" ],
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/storage_account_id",
  :display_name => "Data Storage Account ID",
  :description => "In order to download the data file to the specified cloud 
   storage location, you need to provide cloud authentication credentials. 
   For Amazon S3, use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID). 
   For Rackspace Cloud Files, use your Rackspace login username (e.g., cred:RACKSPACE_USERNAME).",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/storage_account_secret",
  :display_name => "Data Storage Account Secret",
  :description => "In order to get the data file to the specified cloud storage 
   location, you will need to provide cloud authentication credentials. 
   For Amazon S3, use your AWS secret access key (e.g., cred:AWS_SECRET_ACCESS_KEY). 
   For Rackspace Cloud Files, use your Rackspace account API key (e.g., cred:RACKSPACE_AUTH_KEY).",
  :required => "optional",
  :recipes => [ "hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/container",
  :display_name => "Data file container",
  :description => "The cloud storage location where the data file will be downloaded from and uploaded to. 
  For Amazon S3, use the bucket name. For Rackspace Cloud Files, use the container name.",
  :required => "optional",
  :recipes => ["hadoop::do_data_import", "hadoop::do_map_reduce" ]

attribute "mapreduce/data/prefix",
  :display_name => "Data file name prefix to download",
  :description => "The prefix that will be used to name/locate.  If there are 
  multiple version, use a timestamp in the filename.  The newest will be 
  picked up first.  Should be a .tar.gz file",
  :required => "optional",
  :recipes => ["hadoop::do_data_import"]

attribute "mapreduce/data/output_prefix",
  :display_name => "Prefix of output file name to upload",
  :description => "The prefix of the output filename.  Output file is tar.gz'd",
  :required => "optional",
  :recipes => ["hadoop::do_map_reduce" ]

attribute "mapreduce/cleanup",
  :display_name => "Delete the destination and Hadoop input/output directories",
  :description => "Removes all the working directories.",
  :choice => [ "yes", "no"],
  :default=>"no",
  :required => "optional",
  :recipes => ["hadoop::do_data_import","hadoop::do_cleanup" ]