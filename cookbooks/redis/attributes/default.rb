case node[:platform]
when "redhat","centos","scientific"
  default[:redis][:install_from] = "package"
  default[:redis][:service_name] = "redis"
  default[:redis][:log_dir] =  "/var/log/redis"
  default[:redis][:conf_dir] = "/etc/redis"
  default[:redis][:pid_dir] = "/var/run/redis"
  default[:redis][:user] =     "redis"
  default[:redis][:deamon] = "redis-server"
  default[:redis][:package]= "redis"
when "debian","ubuntu"
  default[:redis][:install_from] = "source"
  default[:redis][:service_name] = "redis-server"
  default[:redis][:log_dir] =  "/var/log/redis"
  default[:redis][:conf_dir] = "/etc/redis"
  default[:redis][:pid_dir] = "/var/run/redis"
  default[:redis][:user] =     "redis"
  default[:redis][:deamon] = "redis-server"
  default[:redis][:package] = "redis-server"
end

default[:redis][:conf_file] = "#{node[:redis][:conf_dir]}/redis.conf"
default[:redis][:bindaddress] = "0.0.0.0"
default[:redis][:port] = "6379"
default[:redis][:timeout] = 300
default[:redis][:service_timeouts] = 300
default[:redis][:dumpdb_filename] = "dump.rdb"
default[:redis][:data_dir] = "/var/lib/redis"
default[:redis][:activerehashing] = "yes" # no to disable, yes to enable
default[:redis][:databases] = 16

default[:redis][:appendonly] = "no"
default[:redis][:appendfsync] = "everysec"
default[:redis][:no_appendfsync_on_rewrite] = "no"

default[:redis][:vm][:enabled] = "no" # no to disable, yes to enable
default[:redis][:vm][:swap_file] = "/var/lib/redis/swap"
default[:redis][:vm][:max_memory] = node["memory"]["total"].to_i * 1024 * 0.7
default[:redis][:vm][:page_size] = 32 # bytes
default[:redis][:vm][:pages] = 134217728 # swap file size is pages * page_size
default[:redis][:vm][:max_threads] = 4

default[:redis][:maxmemory_samples] = 3
default[:redis][:maxmemory_policy] = "volatile-lru"
