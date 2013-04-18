Deescription
===========

This cookbook will install and configure a Cassandra ring.
More info about Cassandra can be found at http://cassandra.apache.org


Attributes
==========

* cassandra/version                 Version of Cassandra to install.
* cassandra/cluster_name            The name of the Cassandra cluster to connect to.
* cassandra/seeds                   Comma separated list of Cassandra hosts which will act as seeds.
* cassandra/num_tokens              Number of tokens assigned to this node.
* cassandra/data_file_directories   Directories where Cassandra data files should reside on disk.
* cassandra/commitlog_directory     Directory where commit logs will be written to.
* cassandra/saved_caches_directory  Directory where the saved caches will be written to.
* cassandra/log4j_directory         Directory where logfiles will be written to.

* Many more which are not optional with pre-configured defaults.

Usage
=====

This cookbook will install the new 1.2 series of Cassandra. Initial token values are no longer needed. This cookbook uses [virtual nodes](http://www.datastax.com/docs/1.2/cluster_architecture/data_distribution#distribution) and [Murmur3Partitioner](http://www.datastax.com/docs/1.2/cluster_architecture/partitioners#m3ppartitioner) for faster hashing. Calculating an initial token per node is no longer necessary.

The easiest way to configure Cassandra seed hosts is to use Elastic IP's (if on AWS). Allocate the number of EIP's you'd like to use for seed hosts, and populate 
a comma separated list of the ***public*** DNS EIP values as the cassandra/seeds input.
