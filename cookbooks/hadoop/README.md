Description
===========
Install and Configure Apache Hadoop 1.03

Requirements
============

* Requires a VM launched from a RightScale managed RightImage.

== KNOWN LIMITATIONS:

There are no known limitations.

Attributes
==========

* See <tt>metadata.rb</tt> for the list of attributes and their description.

Usage
=====
This cookbook has two features

1. Launch one Namenode (master server) and unlimited Datanode (slave) servers.
Use the ServerTemplate inputs to select which type of server you will launch.  
The default server launched is a NameNode, simply change the hadoop/node/type input
to datanode to launch a namenode.  Clone as many datanode servers you need or put datanode
servers in a ServerArray to launch as many as you need.

2. Run MapReduce commands using java classes.  Data is downloaded from your ROS
and copied into your HDFS input directory.  After your MapReduce program is run, the 
output data is uploaded to your ROS.


= LICENSE:

Copyright RightScale, Inc. All rights reserved.  All access and use subject to
the RightScale Terms of Service available at http://www.rightscale.com/terms.php
and, if applicable, other agreements such as a RightScale Master Subscription
Agreement.

