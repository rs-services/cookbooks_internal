include_recipe "redis2"
include_recipe "runit"

log "Creating Directory /mnt/#{node[:redis2][:storage_type]}/redis with owner #{node[:redis2][:user]}"
directory "/mnt/#{node[:redis2][:storage_type]}/redis" do
  action :create
  owner "#{node[:redis2][:user]}"
  group "#{node[:redis2][:user]}"
  mode "0755"
  recursive true
  notifies :restart, "service[#{node[:redis2][:instance_name]}]", :delayed
end

link "/var/lib/redis/default" do
  to "/mnt/#{node[:redis2][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis2][:instance_name]}"
