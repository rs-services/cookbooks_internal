# 
# Cookbook Name:: Nuodb
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# Sinlge tag right now till type install etc.. are implemented
nuodb "set peer" do
  action :set_peer
end

rightscale_marker :end
