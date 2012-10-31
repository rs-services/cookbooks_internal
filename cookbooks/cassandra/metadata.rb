maintainer       "RightScale Inc."
maintainer_email "ps@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures cassandra"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.6.2"

supports "ubuntu", "~> 10.04"

depends "apt"
depends "rightscale"

recipe "cassandra::install"   , "Add the Apache Cassandra repo and install software."
recipe "cassandra::configure" , "Install Cassandra config files from Chef templates."

#### Required inputs ####

attribute "cassandra/version",
  :description  => "Version string of Cassandra to install. This can be seen here: http://apache.org/dist/cassandra/debian/dists/11x/main/binary-amd64/Packages This recipe only installs 1.1.x",
  :recipes      => ["cassandra::install"],
  :type         => "string",
  :display_name => "version",
  :required     => "recommended",
  :default      => "1.1.6"

attribute "cassandra/cluster_name",
  :description  => "Name of the Cassandra cluster.",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "cluster_name",
  :required     => "required"

attribute "cassandra/node_number",
  :description  => "Cassandra ring  position (Should be between 1..N).",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "node_number",
  :required     => "required"

attribute "cassandra/node_total",
  :description  => "Total number of nodes in the Cassandra ring.",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "node_total",
  :required     => "required"

attribute "cassandra/seeds",
  :description  => "Comma seperated list of seed hosts",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "seeds",
  :required     => "recommended"

attribute "cassandra/data_file_directories",
  :description  => "Directories where Cassandra should store data on disk.",
  :recipes      => ["cassandra::install", "cassandra::configure"],
  :type         => "array",
  :display_name => "data_file_directories",
  :required     => "required"

attribute "cassandra/commitlog_directory",
  :description  => "Directory where commit logs will be written to.",
  :recipes      => ["cassandra::install",  "cassandra::configure"],
  :type         => "string",
  :display_name => "commitlog_directory",
  :required     => "required"

attribute "cassandra/saved_caches_directory",
  :description  => "Directory where saved caches will be written to.",
  :recipes      => ["cassandra::install", "cassandra::configure"],
  :type         => "string",
  :display_name => "saved_caches_directory",
  :required     => "required"

attribute "cassandra/log4j_directory",
  :description  => "Directory where the main logfile will be written to",
  :recipes      => ["cassandra::install"],
  :type         => "string",
  :display_name => "log4j_directory",
  :required     => "required"

#### Optional inputs ####

attribute "cassandra/hinted_handoff_enabled",
  :description  => "Write hints to the coordinator node if a node is unavailable?",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "hinted_handoff_enabled",
  :choice       => ["true", "false"],
  :required     => "optional",
  :default      => "true"

attribute "cassandra/max_hint_window_in_ms",
  :description  => "This defines the maximum amount of time a dead host will have hints generated.  After it has been dead this long, hints will be dropped.",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "max_hint_window_in_ms",
  :required     => "optional",
  :default      => "3600000"

attribute "cassandra/hinted_handoff_throttle_delay_in_ms",
  :description  => "Sleep this long after delivering each hint.",
  :recipes      => ["cassandra::configure"],
  :type         => "string",
  :display_name => "hinted_handoff_throttle_delay_in_ms",
  :required     => "optional",
  :default      => "1"

attribute "cassandra/key_cache_size_in_mb",
  :description => "Default value is empty to make it auto (min(5% of Heap (in MB), 100MB)). Set to 0 to disable key cache.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => ""

attribute "cassandra/key_cache_save_period",
  :description => "Duration in seconds after which Cassandra should save the keys cache. Caches are saved to saved_caches_directory as specified in this configuration file.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "14400"

attribute "cassandra/row_cache_size_in_mb",
  :description => "Maximum size of the row cache in memory. If you reduce the size, you may not get the hottest keys loaded on startup. Default value is 0, to disable roav caching.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0"

attribute "cassandra/row_cache_save_period",
  :description => "Duration in seconds after which Cassandra should save the row cache. Caches are saved to saved_caches_directory. Saved caches greatly improve cold start speeds, and is relatively cheap in terms of I/O for the key cache. Row cache saving is much more expensive and has limited use. Default is 0 to disable saving the row cache",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0"

attribute "cassandra/commitlog_sync",
  :description => "commitlog_sync may be either periodic or batch. When in batch mode, Cassandra won't ack writes until the commit log has been fsynced to disk. It will wait up to commitlog_sync_batch_window_in_ms milliseconds for other writes, before # performing the sync.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "periodic"

attribute "cassandra/commitlog_sync_period_in_ms",
  :description => "Amount of time in milliseconds between commit log syncs.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "10000"

attribute "cassandra/commitlog_segment_size_in_mb",
  :description => "The default size is 32, which is almost always fine, but if you are archiving commitlog segments (see commitlog_archiving.properties), then you probably want a finer granularity of archiving; 8 or 16 MB is reasonable.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "32"

attribute "cassandra/flush_largest_memtables_at",
  :description => "Emergency pressure valve: each time heap usage after a full (CMS) garbage collection is above this fraction of the max, Cassandra will flush the largest memtables.  Set to 1.0 to disable.  Setting this lower than CMSInitiatingOccupancyFraction is not likely to be useful.  RELYING ON THIS AS YOUR PRIMARY TUNING MECHANISM WILL WORK POORLY: it is most effective under light to moderate load, or read-heavy workloads; under truly massive write load, it will often be too little, too late.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0.75"
 
attribute "cassandra/reduce_cache_sizes_at",
  :description => "Emergency pressure valve #2: the first time heap usage after a full (CMS) garbage collection is above this fraction of the max, Cassandra will reduce cache maximum _capacity_ to the given fraction of the current _size_.  Should usually be set substantially above flush_largest_memtables_at, since that will have less long-term impact on the system.  Set to 1.0 to disable.  Setting this lower than CMSInitiatingOccupancyFraction is not likely to be useful.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0.85"

attribute "cassandra/reduce_cache_capacity_to",
  :description => "Emergency pressure valve #2: the first time heap usage after a full (CMS) garbage collection is above this fraction of the max, Cassandra will reduce cache maximum _capacity_ to the given fraction of the current _size_.  Should usually be set substantially above flush_largest_memtables_at, since that will have less long-term impact on the system.  Set to 1.0 to disable.  Setting this lower than CMSInitiatingOccupancyFraction is not likely to be useful.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0.6"

attribute "cassandra/concurrent_reads",
  :description => "For workloads with more data than can fit in memory, Cassandra's bottleneck will be reads that need to fetch data from disk. 'concurrent_reads' should be set to (16 * number_of_drives) in order to allow the operations to enqueue low enough in the stack that the OS and drives can reorder them.  On the other hand, since writes are almost never IO bound, the ideal number of 'concurrent_writes' is dependent on the number of cores in your system; (8 * number_of_cores) is a good rule of thumb.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "32"

attribute "cassandra/concurrent_writes",
  :description => "For workloads with more data than can fit in memory, Cassandra's bottleneck will be reads that need to fetch data from disk. 'concurrent_reads' should be set to (16 * number_of_drives) in order to allow the operations to enqueue low enough in the stack that the OS and drives can reorder them.  On the other hand, since writes are almost never IO bound, the ideal number of 'concurrent_writes' is dependent on the number of cores in your system; (8 * number_of_cores) is a good rule of thumb.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "32"

attribute "cassandra/memtable_flush_queue_size",
  :description => "The number of full memtables to allow pending flush, that is, waiting for a writer thread.  At a minimum, this should be set to the maximum number of secondary indexes created on a single CF.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "4"

attribute "cassandra/trickle_fsync",
  :description => "Whether to, when doing sequential writing, fsync() at intervals in order to force the operating system to flush the dirty buffers. Enable this to avoid sudden dirty buffer flushing from impacting read latencies. Almost always a good idea on SSD:s; not necessarily on platters.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "false"

attribute "cassandra/trickle_fsync_interval_in_kb",
  :description => "Whether to, when doing sequential writing, fsync() at intervals in order to force the operating system to flush the dirty buffers. Enable this to avoid sudden dirty buffer flushing from impacting read latencies. Almost always a good idea on SSD:s; not necessarily on platters.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "10240"

attribute "cassandra/storage_port",
  :description => "TCP Port, for commands and data.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "7000"

attribute "cassandra/ssl_storage_port",
  :description => "SSL port, for encrypted communication.  Unused unless enabled in encryption_options.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "7001"

attribute "cassandra/listen_address",
  :description => "Address to bind to and tell other Cassandra nodes to connect to. You _must_ change this if you want multiple nodes to be able to communicate! Leaving it blank leaves it up to InetAddress.getLocalHost(). This will always do the Right Thing *if* the node is properly configured (hostname, name resolution, etc), and the Right Thing is to use the address associated with the hostname (it might not be). Setting this to 0.0.0.0 is always wrong.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => ""

attribute "cassandra/rpc_address",
  :description => "Address to broadcast to other Cassandra nodes Leaving this blank will set it to the same value as listen_address broadcast_address: 1.2.3.4 The address to bind the Thrift RPC service to -- clients connect here. Unlike ListenAddress above, you *can* specify 0.0.0.0 here if you want Thrift to listen on all interfaces.  Leaving this blank has the same effect it does for ListenAddress, (i.e. it will be based on the configured hostname of the node).",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0.0.0.0"

attribute "cassandra/rpc_port",
  :description => "Port for Thrift to listen for clients on.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "9160"

attribute "cassandra/rpc_keepalive",
  :description => "Enable or disable keepalive on rpc connections",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "true"

attribute "cassandra/rpc_server_type",
  :description => "Cassandra provides three optionals for the RPC server.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :choice      => ["sync", "async", "hsha"],
  :default     => "sync"

attribute "cassandra/thrift_framed_transport_size_in_mb",
  :description => "Frame size for thrift (maximum field length).  0 disables TFramedTransport in favor of TSocket. This option is deprecated; we strongly recommend using Framed mode.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "15"

attribute "cassandra/thrift_max_message_length_in_mb",
  :description => "The max length of a thrift message, including all fields and internal thrift overhead.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "16"

attribute "cassandra/incremental_backups",
  :description => "Set to true to have Cassandra create a hard link to each sstable flushed or streamed locally in a backups/ subdirectory of the Keyspace data.  Removing these links is the operator's responsibility.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "false"

attribute "cassandra/snapshot_before_compaction",
  :description => "Whether or not to take a snapshot before each compaction. Be careful using this option, since Cassandra won't clean up the snapshots for you. Mostly useful if you're paranoid when there is a data format change.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "false"

attribute "cassandra/auto_snapshot",
  :description => "Whether or not a snapshot is taken of the data before keyspace truncation or dropping of column families. The STRONGLY advised default of true should be used to provide data safety. If you set this flag to false, you will lose data on truncation or drop.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "true"

attribute "cassandra/column_index_size_in_kb",
  :description => "Add column indexes to a row after its contents reach this size.  Increase if your column values are large, or if you have a very large number of columns.  The competing causes are, Cassandra has to deserialize this much of the row to read a single column, so you want it to be small - at least if you do many partial-row reads - but all the index data is read for each access, so you don't want to generate that wastefully either.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "64"

attribute "cassandra/in_memory_compaction_limit_in_mb",
  :description => "Size limit for rows being compacted in memory.  Larger rows will spill over to disk and use a slower two-pass compaction process.  A message will be logged specifying the row key.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "64"

attribute "cassandra/multithreaded_compaction",
  :description => "Multi-threaded compaction. When enabled, each compaction will use up to one thread per core, plus one thread per sstable being merged.  This is usually only useful for SSD-based hardware: otherwise, your concern is usually to get compaction to do LESS i/o (see: compaction_throughput_mb_per_sec), not more.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "false"

attribute "cassandra/compaction_throughput_mb_per_sec",
  :description => "Throttles compaction to the given total throughput across the entire system. The faster you insert data, the faster you need to compact in order to keep the sstable count down, but in general, setting this to 16 to 32 times the rate you are inserting data is more than sufficient.  Setting this to 0 disables throttling. Note that this account for all types of compaction, including validation compaction.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "16"

attribute "cassandra/compaction_preheat_key_cache",
  :description => "Track cached row keys during compaction, and re-cache their new positions in the compacted sstable. Disable if you use really large key caches.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "true"

attribute "cassandra/rpc_timeout_in_ms",
  :description => "Time to wait for a reply from other nodes before failing the command",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "10000"

attribute "cassandra/endpoint_snitch",
  :description => "Network replication to be used",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :choice      => ["SimpleSnitch", "PropertyFileSnitch", "GossipingPropertyFileSnitch", "RackInferringSnitch", "Ec2Snitch", "Ec2MultiRegionSnitch"],
  :default     => "SimpleSnitch"

attribute "cassandra/dynamic_snitch_update_interval_in_ms",
  :description => "Controls how often to perform the more expensive part of host score calculation",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "100"
 
attribute "cassandra/dynamic_snitch_reset_interval_in_ms",
  :description => "Controls how often to reset all host scores, allowing a bad host to possibly recover",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "600000"

attribute "cassandra/dynamic_snitch_badness_threshold",
  :description => "If set greater than zero and read_repair_chance is < 1.0, this will allow 'pinning' of replicas to hosts in order to increase cache capacity.  The badness threshold will control how much worse the pinned host has to be before the dynamic snitch will prefer other replicas over it.  This is expressed as a double which represents a percentage.  Thus, a value of 0.2 means Cassandra would continue to prefer the static snitch values until the pinned host was 20% worse than the fastest.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "0.1"

attribute "cassandra/request_scheduler",
  :description => "Set this to a class that implements RequestScheduler, which will schedule incoming client requests according to the specific policy. This is useful for multi-tenancy with a single Cassandra cluster.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :choice      => ["org.apache.cassandra.scheduler.NoScheduler", "org.apache.cassandra.scheduler.RoundRobinScheduler"],
  :default     => "org.apache.cassandra.scheduler.NoScheduler"

attribute "cassandra/index_interval",
  :description => "index_interval controls the sampling of entries from the primrary row index in terms of space versus time.  The larger the interval, the smaller and less effective the sampling will be.  In technicial terms, the interval coresponds to the number of index entries that are skipped between taking each sample.  All the sampled entries must fit in memory.  Generally, a value between 128 and 512 here coupled with a large key cache size on CFs results in the best trade offs.  This value is not often changed, however if you have many very small rows (many to an OS page), then increasing this will often lower memory usage without a impact on performance.",
  :recipes     => ["cassandra::configure"],
  :type        => "string",
  :required    => "optional",
  :default     => "128"
