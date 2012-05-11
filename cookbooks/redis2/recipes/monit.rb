include_recipe "monit"
monit_process "redis" do
  enable true
  process_name "redis-server"
  pidfile "/var/run/redis/default.pid"
  start_cmd "service redis-server start"
  stop_cmd "service redis-server stop"
end
