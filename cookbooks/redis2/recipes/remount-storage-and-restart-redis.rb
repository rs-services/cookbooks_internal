include_recipe "redis2"
include_recipe "runit"

directory "/mnt/#{node[:redis][:storage_type]}/redis" do
  action :create
  owner "#{node[:redis][:app_user]}"
  group "#{node[:redis][:app_user]}"
  mode "0755"
  recursive true
  notifies :restart, "service[#{node[:redis][:instance_name]}]", :delayed
end

link "/var/lib/redis/default" do
  to "/mnt/#{node[:redis][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis][:instance_name]}"
