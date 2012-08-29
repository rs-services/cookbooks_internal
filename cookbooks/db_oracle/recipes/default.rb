#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# check passwords first 
include RightScale::Database::Oracle::Helper
check_password("sys", node[:db][:sys][:password])
check_password("sysdba", node[:db][:sysdba][:password])
check_password("system", node[:db][:system][:password])
check_password("dbsnmp", node[:db][:dbsnmp][:password])
check_password(node[:db][:admin][:user], node[:db][:admin][:password])
check_password(node[:db][:application][:user], node[:db][:application][:password])


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
