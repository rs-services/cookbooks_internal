maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Copyright RightScale, Inc. All rights reserved."
description      "Provides the Percona implementation of the 'db' resource to" +
                 " install and manage Percona database stand-alone servers and clients."
version          "13.5.20"

supports "centos"
supports "redhat"
supports "ubuntu"

depends "db"
depends "block_device"
depends "sys_dns"
depends "rightscale"

recipe "db_percona::setup_server_5_5",
  "Sets the DB Percona provider. Sets version 5.5 and node variables specific" +
  " to Percona 5.5."


