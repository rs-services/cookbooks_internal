# Default instance of redis.
#
#
rs_utils_marker :begin

include_recipe "redis2"

redis_instance "default"

rs_utils_marker :end
