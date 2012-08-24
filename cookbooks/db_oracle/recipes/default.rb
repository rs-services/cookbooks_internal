#
# Cookbook Name:: db_mysql
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

node[:db][:provider] = "db_oracle"
version = node[:db_oracle][:version]

node[:db_oracle][:client_packages_install] = 
  %w{elfutils-libelf-devel glibc-devel gcc gcc-c++ libaio 
glibc-devel libaio-devel libstdc++ libstdc++ libstdc++-devel 
libgcc libstdc++-devel unixODBC unixODBC-devel}

node[:db_oracle][:server_packages_uninstall]=""
node[:db_oracle][:server_packages_install] = %w{compat-libstdc++-33 glibc-devel libaio-devel 
sysstat unixODBC-devel pdksh elfutils-libelf-devel unixODBC}

rightscale_marker :end
