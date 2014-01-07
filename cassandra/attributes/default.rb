#
# Cookbook Name:: cassandra
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

default[:cassandra][:version]          = "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/cassandra12-1.2.6-1.noarch.rpm"
default[:cassandra][:version_rpm]      = "cassandra12-1.2.6-1.noarch.rpm"

default[:cassandra][:datastax]         = "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/dsc12-1.2.6-1.noarch.rpm"
default[:cassandra][:datastax_rpm]     = "dsc12-1.2.6-1.noarch.rpm"

default[:cassandra][:jre]              = "http://rs-professional-services-publishing.s3.amazonaws.com/cassandra/jre-7u45-linux-x64.rpm"
default[:cassandra][:jre_rpm]          = "jre-7u45-linux-x64.rpm"

default[:cassandra][:us_export_policy] = "https://rs-professional-services-publishing.s3.amazonaws.com/cassandra/US_export_policy.jar"
default[:cassandra][:local_policy]     = "https://rs-professional-services-publishing.s3.amazonaws.com/cassandra/local_policy.jar"
