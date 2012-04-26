include_recipe "redis2"
include_recipe "runit"

service "#{node[:redis2][:instance_name]}" do
  action :stop
end

log "Creating Directory /mnt/#{node[:redis2][:storage_type]}/redis with owner #{node[:redis2][:user]}"
directory "/mnt/#{node[:redis2][:storage_type]}/redis" do
  action :create
  owner "#{node[:redis2][:user]}"
  group "#{node[:redis2][:user]}"
  mode "0755"
  recursive true
end

log "Moving Data from /var/lib/redis/default to new storage location: /mnt/#{node[:redis2][:storage_type]}/redis"
bash "move-redis-dbs" do
  user "root"
  cwd "/"
  flags "-ex"
  code <<-EOF
    mv /var/lib/redis/default/* /mnt/#{node[:redis2][:storage_type]}/redis
EOF
end

log "Deleting /var/lib/redis/default to make symlink"
directory "/var/lib/redis/default" do
  action :delete
  recursive true
end
 
log "linking /mnt/#{node[:redis2][:storage_type]}/redis to /var/lib/redis/default"
link "/var/lib/redis/default" do
  to "/mnt/#{node[:redis2][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis2][:instance_name]}" do
  action :start
end
