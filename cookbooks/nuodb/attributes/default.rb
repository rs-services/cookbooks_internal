default[:nuodb][:nuodb_alt_addr] = node[:cloud][:private_ips][0]
default[:nuodb_peers] = []
default[:nuodb][:nuodb_type] = "broker+peer"
default[:nuodb][:nuodb_download_url] = "http://www.nuodb.com/latest/nuodb-1.0-GA.linux.x86_64.rpm"
default[:nuodb][:nuodb_broker_flag] = "true"
default[:nuodb][:nuodb_domain] = "domain"
default[:nuodb][:nuodb_domain_password] = "bird"
default[:nuodb][:nuodb_port] = "48004"
default[:nuodb][:nuodb_advertise_alt] = "true"
default[:nuodb][:nuodb_bindir] = "."
default[:nuodb][:nuodb_portrange] = "broadcast"
default[:nuodb][:nuodb_require_connect_key] = "false"
default[:nuodb][:nuodb_database] = "test"
default[:nuodb][:nuodb_dba_user] = "dba"
default[:nuodb][:nuodb_dba_password] = "goalie"
default[:nuodb][:nuodb_archive_location] = "test"
default[:nuodb][:nuodb_arch_int_flag] = "test"

