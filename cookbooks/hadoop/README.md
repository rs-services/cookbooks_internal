Description
===========
Install and Configure Apache Hadoop 1.03

Requirements
============
Java


Attributes
==========

Usage
=====

To create a Hadoop Cluster, create multiple servers.  Each server will be 
designated as a namenode (master) or datanode (slave).  

Set the hadoop/dfs/replication input to the size of your datanode replication size.


MapReduce

There are three recipes for MapReduce 
 1. hadoop::do_data_import - runs hadoop::do_cleanup (if mapreduce/cleanup==yes) then downloads data and copies it to the hadoop HDFS
 2. hadoop::do_map_reduce - downloads MapReduce code from Repository compiles it, 
    runs MapReduce program and uploads it to the ROS

