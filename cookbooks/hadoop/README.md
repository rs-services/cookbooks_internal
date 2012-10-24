= Description

Install and Configure Apache Hadoop 1.03 

= Requirements


* Requires a VM launched from a RightScale managed RightImage.

= KNOWN LIMITATIONS:

There are no known limitations.

= Attributes:

* See metadata.rb for the list of attributes and their description.

= Usage:

If your cloud supports Security Groups, i.e. Amazon EC2, set the rules to allow 
ports 8020, 50000-50100 (or the ports you use in the inputs) between namenode 
and datanodes.

This cookbook has two features

1. Launch one Namenode (master server) and unlimited Datanode (slave) servers.
Use the ServerTemplate inputs to select which type of server you will launch.  
The default server launched is a NameNode, simply change the attribute hadoop/node/type input
to datanode to launch a datanode.  Clone as many datanode servers you need or put datanode
servers in a ServerArray to launch as many as you need.

2. Run MapReduce commands using java classes.  Data is downloaded from your ROS
and copied into your HDFS input directory.  After your MapReduce program is run, the 
output data is uploaded to your ROS.


= LICENSE:

Copyright RightScale, Inc. All rights reserved.  All access and use subject to
the RightScale Terms of Service available at http://www.rightscale.com/terms.php
and, if applicable, other agreements such as a RightScale Master Subscription
Agreement.

