#
# Cookbook Name:: app_jboss
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# By default tomcat uses MySQL as the DB adapter
#A- set_unless[:app][:db_adapter] = "mysql"
# List of required apache modules
#A- set[:app][:module_dependencies] = ["proxy", "proxy_http", "deflate", "rewrite"]
#
