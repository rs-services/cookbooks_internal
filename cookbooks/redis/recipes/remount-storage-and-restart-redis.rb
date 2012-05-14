include_recipe "redis"

service "#{node[:redis][:service_name]}" do
  action :stop
end

log "Creating Directory /mnt/#{node[:redis][:storage_type]}/redis with owner #{node[:redis][:user]}"
directory "/mnt/#{node[:redis][:storage_type]}/redis" do
  action :create
  owner "#{node[:redis][:user]}"
  group "#{node[:redis][:user]}"
  mode "0755"
  recursive true
end

log "Moving Data from /var/lib/redis/default to new storage location: /mnt/#{node[:redis][:storage_type]}/redis"
bash "move-redis-dbs" do
  user "root"
  cwd "/"
  flags "-ex"
  code <<-EOF
    if [ -e /var/lib/redis/default/* ]; then
    mv /var/lib/redis/default/* /mnt/#{node[:redis][:storage_type]}/redis
    fi
EOF
  not_if "test -e /mnt/#{node[:redis][:storage_type]}/redis/#{node[:redis][:instances][:default][:dumpdb_filename]}"
end

log "Deleting /var/lib/redis/default to make symlink"
directory "/var/lib/redis/default" do
  action :delete
  recursive true
end
 
log "linking /mnt/#{node[:redis][:storage_type]}/redis to /var/lib/redis/default"
link "/var/lib/redis/default" do
  to "/mnt/#{node[:redis][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis][:service_name]}" do
  action :start
end
