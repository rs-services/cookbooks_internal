#
# Cookbook Name:: cassandra
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

#
def value_with_units(value, units, usage_factor)
  raise "Error: value must convert to an integer." unless value.to_i
  raise "Error: units must be k, m, g" unless units =~ /[KMG]/i
  factor = usage_factor.to_f
  raise "Error: usage_factor is 1.0  Value used: #{usage_factor}" if factor > 1.0 || factor <= 0.0
  (value * factor).to_i.to_s + units
end

#
# Set memory parameters in the cassandra.yaml file.
#

usage = 1 

# Ohai returns total in KB. Set GB so X*GB can be used in conditional
GB=1024*1024

mem = memory[:total].to_i/1024
Chef::Log.info("Auto-tuning Cassandra parameters. Total memory: #{mem}M")
one_percent_mem = (mem*0.01).to_i
one_percent_str=value_with_units(one_percent_mem,"M",usage)
fifty_percent_mem = (mem*0.50).to_i
fifty_percent_str=value_with_units(fifty_percent_mem,"M",usage)
eighty_percent_mem = (mem*0.80).to_i
eighty_percent_str=value_with_units(eighty_percent_mem,"M",usage)

#
# Fixed parameters, common value for all instance sizes
#
# These parameters may be to large for verry small instance sizes with < 1gb memory.
#

#
# Adjust based on memory range.
#
# The memory ranges used are < 1GB, 1GB - 3GB, 3GB - 10GB, 10GB - 25GB, 25GB - 50GB, > 50GB.
if mem < 1*GB
  set_unless[:Cassandra][:memtable_total_space_in_mb] = eighty_percent_str.slice(0,(eighty_percent_str.length-1))
  set_unless[:Cassandra][:commitlog_total_space_in_mb] = fifty_percent_str.slice(0,(fifty_percent_str.length-1))
  set_unless[:Cassandra][:MAX_HEAP_SIZE] = eighty_percent_str
  set_unless[:Cassandra][:HEAP_NEWSIZE] = fifty_percent_str

elseif mem < 3*GB
  
  set_unless[:Cassandra][:memtable_total_space_in_mb] = eighty_percent_str.slice(0,(eighty_percent_str.length-1))
  set_unless[:Cassandra][:commitlog_total_space_in_mb] = fifty_percent_str.slice(0,(fifty_percent_str.length-1))
  set_unless[:Cassandra][:MAX_HEAP_SIZE] = eighty_percent_str
  set_unless[:Cassandra][:HEAP_NEWSIZE] = fifty_percent_str

elsif mem < 10*GB
 
  set_unless[:Cassandra][:memtable_total_space_in_mb] = eighty_percent_str.slice(0,(eighty_percent_str.length-1))
  set_unless[:Cassandra][:commitlog_total_space_in_mb] = fifty_percent_str.slice(0,(fifty_percent_str.length-1))
  set_unless[:Cassandra][:MAX_HEAP_SIZE] = eighty_percent_str
  set_unless[:Cassandra][:HEAP_NEWSIZE] = fifty_percent_str

elsif mem < 25*GB

  set_unless[:Cassandra][:memtable_total_space_in_mb] = eighty_percent_str.slice(0,(eighty_percent_str.length-1))
  set_unless[:Cassandra][:commitlog_total_space_in_mb] = fifty_percent_str.slice(0,(fifty_percent_str.length-1))
  set_unless[:Cassandra][:MAX_HEAP_SIZE] = eighty_percent_str
  set_unless[:Cassandra][:HEAP_NEWSIZE] = fifty_percent_str

elsif mem < 50*GB

  set_unless[:Cassandra][:memtable_total_space_in_mb] = eighty_percent_str.slice(0,(eighty_percent_str.length-1))
  set_unless[:Cassandra][:commitlog_total_space_in_mb] = fifty_percent_str.slice(0,(fifty_percent_str.length-1))
  set_unless[:Cassandra][:MAX_HEAP_SIZE] = eighty_percent_str
  set_unless[:Cassandra][:HEAP_NEWSIZE] = fifty_percent_str

else

end

