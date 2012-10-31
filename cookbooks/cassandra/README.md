Description
===========

This cookbook will install and configure a Cassandra ring.
More info about Cassandra can be found at http://cassandra.apache.org


Requirements
============

Requires the [apt](http://community.opscode.com/cookbooks/apt) cookbook from http://community.opscode.com


Attributes
==========

* cassandra/version                 Version of Cassandra to install.
* cassandra/cluster_name            The name of the Cassandra cluster to connect to.
* cassandra/node_number             The position of this host in the Cassandra ring.
* cassandra/node_total              The total number of hosts in the Cassandra ring.
* cassandra/seeds                   Comma separated list of Cassandra hosts which will act as seeds.
* cassandra/data_file_directories   Directories where Cassandra data files should reside on disk.
* cassandra/commitlog_directory     Directory where commit logs will be written to.
* cassandra/saved_caches_directory  Directory where the saved caches will be written to.
* cassandra/log4j_directory         Directory where logfiles will be written to.

* Many more which are not optional with pre-configured defaults.

Usage
=====

Set the input cassandra/node_number on each Cassandra instance in the Cassandra ring. Node numbers should range from 1..N.

The easiest way to configure Cassandra seed hosts is to use Elastic IP's. Allocate the number of EIP's you'd like to use for seed hosts, and populate 
a comma separated list of the public DNS EIP values as the cassandra/seeds input. After booting run the cassandra::configure recipe on each node, 
and this will write the proper cassandra.yml config file to the node and restart Cassandra. Nodes should be reconfigured one at a time before moving to
the next node. 

Note: For easier installation/configuration the cassandra::configure script can be moved from Operational Scripts to Boot Scripts if you are running on AWS and using EIPs. 
Since EIP's are not available on non AWS clouds configuring seed hosts is a bit more cumbersome. Since instance internal IP's are not known before booting, the number of hosts 
which are to be used as seed nodes first need to be booted, the cassandra/seeds input then populated with these 10.x private addresses and then the cassandra::configure script run
on subsequent nodes. 


Known Issues
============

* Only tested on a v13 ServerTemplate.
* This cookbook only installs the 1.1.x series of Cassandra.
* It has only been tested on Ubuntu 10.04 on AWS, CentOS support will be added very soon.
* This cookbook does not support resizing the Cassandra ring at this time.
* This cookbook only supports single Datacenter Cassandra deployments.
