#
# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

cluster_tag = node[:db_couchbase][:cluster][:tag]
log("db_couchbase/cluster/tag: #{cluster_tag}")


log"setting right_link_tag to couchbase:cluster_tag=#{cluster_tag}"
right_link_tag "couchbase:cluster_tag=#{cluster_tag}"

log"setting right_link_tag to couchbase:listen_ip=#{node[:couchbase][:ip]}"
right_link_tag "couchbase:listen_ip=#{node[:couchbase][:ip]}"

# END of RS tag section

rightscale_marker :end
