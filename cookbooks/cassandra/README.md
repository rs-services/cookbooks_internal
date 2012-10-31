Description
===========

This cookbook will install and configure a Cassandra ring.
More info about Cassandra can be found at http://cassandra.apache.org

Requirements
============

Requires the apt cookbook from community.opscode.com


Attributes
==========

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


