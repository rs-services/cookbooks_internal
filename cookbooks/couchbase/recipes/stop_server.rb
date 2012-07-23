Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


rightscale_marker :begin

log("service couchbase-server stop")

command "/etc/init.d/couchbase-server stop && sleep 15"

rightscale_marker :end


