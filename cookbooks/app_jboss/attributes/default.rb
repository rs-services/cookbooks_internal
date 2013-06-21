default["app_jboss"]["source"]                        = "http://stefhen-rightscale.s3.amazonaws.com/jboss-as-7.1.1.Final.tar.gz"
default["app_jboss"]["source_sha256"]                 = "88fd3fdac4f7951cee3396eff3d70e8166c3319de82d77374a24e3b422e0b2ad"

default["app_jboss"]["source_mysql_connector"]        = "http://stefhen-rightscale.s3.amazonaws.com/mysql-connector-java-5.1.25.tar.gz"
default["app_jboss"]["source_mysql_connector_sha256"] = "560073733f13df334a6320cf381db78ea3c167e0c578ca18b9f077a8269a0d92"

default[:app_jboss][:private_ip] = node[:cloud][:private_ips][0]
