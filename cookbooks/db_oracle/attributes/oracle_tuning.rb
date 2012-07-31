#
# Cookbook Name:: db_mysql
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


# Adjust values based on a usage factor and create human readable string
def value_with_units(value, units, usage_factor)
  raise "Error: value must convert to an integer." unless value.to_i
  raise "Error: units must be k, m, g" unless units =~ /[KMG]/i
  factor = usage_factor.to_f
  raise "Error: usage_factor must be between 1.0 and 0.0. Value used: #{usage_factor}" if factor > 1.0 || factor <= 0.0 
  (value * factor).to_i.to_s + units
end


# Set tuning parameters in the my.cnf file.
#
# Shared servers get %50 of the resources allocated to a dedicated server.
set_unless[:db_mysql][:server_usage] = "dedicated"  # or "shared"
usage = 1 # Dedicated server
usage = 0.5 if db_mysql[:server_usage] == "shared"

# Ohai returns total in KB.  Set GB so X*GB can be used in conditional
GB=1024*1024

mem = memory[:total].to_i/1024
Chef::Log.info("  Auto-tuning MySQL parameters.  Total memory: #{mem}M")
one_percent_mem = (mem*0.01).to_i
one_percent_str=value_with_units(one_percent_mem,"M",usage)
fifty_percent_mem = (mem*0.50).to_i
fifty_percent_str=value_with_units(fifty_percent_mem,"M",usage)
eighty_percent_mem = (mem*0.80).to_i
eighty_percent_str=value_with_units(eighty_percent_mem,"M",usage)


# Fixed parameters, common value for all instance sizes
#
# These parameters may be to large for very small instance sizes with < 1gb memory.
set_unless[:db_mysql][:tunable][:thread_cache_size]                 = (50 * usage).to_i
set_unless[:db_mysql][:tunable][:max_connections]                   = (800 * usage).to_i

# Calculate as a percentage of memory
Chef::Log.info("  Setting query_cache_size to: #{one_percent_str}")
set_unless[:db_mysql][:tunable][:query_cache_size]                  = one_percent_str
Chef::Log.info("  Setting query_cache_size to: #{eighty_percent_str}")
set_unless[:db_mysql][:tunable][:innodb_buffer_pool_size]           = eighty_percent_str
