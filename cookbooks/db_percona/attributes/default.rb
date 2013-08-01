#
# Cookbook Name:: db_percona
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

# Recommended attributes

default[:db_percona][:collectd_master_slave_mode] = ""

# Optional attributes

default[:db_percona][:port] = "3306"
default[:db_percona][:log_bin_enabled] = true
default[:db_percona][:log_bin] = "/mnt/ephemeral/mysql-binlogs/mysql-bin"
default[:db_percona][:binlog_format] = "MIXED"
default[:db_percona][:tmpdir] = "/mnt/ephemeral/mysqltmp"
default[:db_percona][:datadir] = "/var/lib/mysql"
default[:db_percona][:enable_percona_upgrade] = "false"
default[:db_percona][:compressed_protocol] = "disabled"
# Always set to support stop/start
set[:db_percona][:bind_address] = "0.0.0.0"

default[:db_percona][:dump][:storage_account_provider] = ""
default[:db_percona][:dump][:storage_account_id] = ""
default[:db_percona][:dump][:storage_account_secret] = ""
default[:db_percona][:dump][:container] = ""
default[:db_percona][:dump][:prefix] = ""

default[:db_percona][:server_usage] = "shared"
default[:db_percona][:init_timeout] = "600"
default[:db_percona][:expire_logs_days] = "2"
default[:db_percona][:tunable][:isamchk] = {}
default[:db_percona][:tunable][:myisamchk] = {}

# SSL attributes
default[:db_percona][:ssl][:ca_certificate] = ""
default[:db_percona][:ssl][:master_certificate] = ""
default[:db_percona][:ssl][:master_key] = ""
default[:db_percona][:ssl][:slave_certificate] = ""
default[:db_percona][:ssl][:slave_key] = ""

# Platform specific attributes

case platform
when "redhat", "centos"
  default[:db_percona][:log] = ""
  default[:db_percona][:log_error] = ""
when "ubuntu"
  default[:db_percona][:log] = "log = /var/log/mysql.log"
  default[:db_percona][:log_error] = "log_error = /var/log/mysql.err"
else
  raise "Unsupported platform #{platform}"
end

# System tuning parameters
# Set the percona and root users max open files to a really large number.
# 1/3 of the overall system file max should be large enough.
# The percentage can be adjusted if necessary.
default[:db_percona][:file_ulimit] = `sysctl -n fs.file-max`.to_i/33

default[:db_percona][:backup][:slave][:max_allowed_lag] = 60
