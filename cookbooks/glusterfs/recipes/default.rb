#Cookbook Name:: glusterclientfs
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

marker "recipe_start"

include_recipe "glusterfs::install"
include_recipe "glusterfs::server_configure"
include_recipe "glusterfs::server_set_tags"



