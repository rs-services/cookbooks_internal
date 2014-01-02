#
# Cookbook Name:: db_percona
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

db 'setup repos' do
  persist true
  provider node[:db][:provider]
  db_version node[:db][:version]
  action :install_repos
end