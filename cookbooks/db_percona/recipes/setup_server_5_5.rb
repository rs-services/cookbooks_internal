#
# Cookbook Name:: db_percona
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

version = "5.5"
node[:db][:version] = version
node[:db][:provider] = "db_percona"


#patch linux.rb, as per Lopaka:
###this code will fix a bug where mounting of the new lvm device happens before it is enabled
###and will raise when the properties of the ubuntu bug shows
linux_rb="/opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/rightscale_tools-1.7.14/lib/rightscale_tools/platform/linux.rb"

if File.exists?(linux_rb)
  COOKBOOK_FILES_PATH = ::File.join(::File.dirname(__FILE__), "..", "files", "default")
  log "  Copying #{COOKBOOK_FILES_PATH}/linux.rb to #{linux_rb}"
  `cp #{COOKBOOK_FILES_PATH}/linux.rb #{linux_rb}`

  linux_rb="#{linux_rb}_cookbook_file"
  log "  Patching #{linux_rb}"
  cookbook_file "#{linux_rb}" do
    action :create
    source "linux.rb"
    mode "0664"
  end
else
  log "  Missing #{linux_rb}"
end

#patch lvm.rb to retry when lvremove fails. This avoids backups failing and leaving the DB locked
`sed -r -i 's/(.*lvremove.*):ignore_failure => true\\)/snap_exists = execute("lvs | grep blockdevice_lvm_snapshot", :ignore_failure => true)\\nif snap_exists\\n\\1:retry_num => 5, :retry_sleep => 10)\\nend/g' /opt/rightscale/sandbox/lib/ruby/gems/1.8/gems/rightscale_tools-*/lib/rightscale_tools/block_device/lvm.rb`
#lvm.rb should then have this:
#          snap_exists = execute("lvs | grep blockdevice_lvm_snapshot", :ignore_failure => true)
#          @platform.lvremove(@snapshot_device, :force => true, :retry_num => 5, :retry_sleep => 10) unless snap_exists.empty?


log "  Setting DB Percona version to #{version}"

# Set MySQL 5.5 specific node variables in this recipe.
#
node[:db][:socket] = value_for_platform(
  "ubuntu" => {
    "default" => "/var/run/mysqld/mysqld.sock"
  },
  "default" => "/var/lib/mysql/mysql.sock"
)

# http://dev.mysql.com/doc/refman/5.5/en/linux-installation-native.html
# For Red Hat and similar distributions, the MySQL distribution is divided into a
# number of separate packages, mysql for the client tools, mysql-server for the
# server and associated tools, and mysql-libs for the libraries.

node[:db_percona][:service_name] = value_for_platform(
  "ubuntu" => {
    "10.04" => "",
    "default" => "mysql"
  },
  "default" => "mysql"
)

node[:db_percona][:server_packages_uninstall] = []

node[:db_percona][:server_packages_install] = value_for_platform(
  "ubuntu" => {
    "10.04" => [],
    "default" => ["percona-server-server-5.5", "iotop"]
  },
  "default" => ["Percona-Server-server-55","Percona-Server-client-55"]
)

node[:db][:init_timeout] = node[:db_percona][:init_timeout]

# Mysql specific commands for db_sys_info.log file
node[:db][:info_file_options] = ["mysql -V", "cat /etc/mysql/conf.d/my.cnf"]
node[:db][:info_file_location] = "/etc/mysql"

log "  Using MySQL service name: #{node[:db_percona][:service_name]}"
