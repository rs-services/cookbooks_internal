include_recipe "monit"
monit_process "redis" do
  enable true
  process_name "#{node[:redis][:deamon]}"
  pidfile "#{node[:redis][:pid_dir]}/redis.pid"
  start_cmd "/etc/init.d/#{node[:redis][:service_name]} start"
  stop_cmd "/etc/init.d/#{node[:redis][:service_name]} stop"
end
