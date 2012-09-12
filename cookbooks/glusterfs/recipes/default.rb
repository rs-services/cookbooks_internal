#Cookbook Name:: glusterclientfs
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

  # debug
  require 'pp'
  pretty = PP.pp(node,'')
  File.open('/tmp/node.js', 'w') { |f| f.write pretty }

rightscale_marker :end

