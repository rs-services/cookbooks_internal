#
# Cookbook Name:: Hadoopo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

log "Starting Hadoop"
hadoop "start hadoop" do
  action :start
end