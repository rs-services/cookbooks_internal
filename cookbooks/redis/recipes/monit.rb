include_recipe "monit"
monit_process "redis" do
  enable true
  process_name "#{node[:redis][:deamon]}"
  pidfile "#{node[:redis][:pid_dir]}/redis.pid"
  start_cmd "service redis-server start"
  stop_cmd "service redis-server stop"
end
