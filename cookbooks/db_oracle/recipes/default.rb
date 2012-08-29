#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# check passwords first 
#include RightScale::Database::Helper
#include RightScale::Database::Oracle::Helper
def check_password(user,password)
  regex = /^(?=.*\d)(?=.*([a-z]|[A-Z])){8,20}/
  raise "Password for #{user} is not strong enough. Password must include letters and numbers and be 8-20 characters long." unless password =~ /#{regex}/
  Chef::Log.info "Password check passed for #{user}!"
end

def check_user_pass(user,password)
  %w{sysman sys sysdba admin dbsnmp system}.each { |name|
    raise "User #{user} is a reserved user, please pick another username" if name.to_s == user.to_s
  }
  check_password(user,password)
end

raise "Admin and Application user names can not be the same" if node[:db][:admin][:user].to_s == node[:db][:application][:user].to_s

check_password("sys", node[:db][:sys][:password])
check_password("sysman", node[:db][:sysman][:password])
check_password("system", node[:db][:system][:password])
check_password("dbsnmp", node[:db][:dbsnmp][:password])
check_user_pass(node[:db][:admin][:user], node[:db][:admin][:password])
check_user_pass(node[:db][:application][:user], node[:db][:application][:password])

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
