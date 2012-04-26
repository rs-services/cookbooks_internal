include_recipe "redis2"
include_recipe "runit"

directory "/mnt/#{node[:redis2][:storage_type]}/redis" do
  action :create
  owner "#{node[:redis2][:app_user]}"
  group "#{node[:redis2][:app_user]}"
  mode "0755"
  recursive true
  notifies :restart, "service[#{node[:redis2][:instance_name]}]", :delayed
end

link "/var/lib/redis/default" do
  to "/mnt/#{node[:redis2][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis2][:instance_name]}"
