#Cookbook Name:: aria2
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

#Installing base packages
 log " Packages which will be installed open-ssl and aria2"

 package "openssl"
 package "aria2"



rs_utils_marker :end

