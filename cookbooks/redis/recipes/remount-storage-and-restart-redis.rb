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

log "Moving Data from #{node[:redis][:data_dir]} to new storage location: /mnt/#{node[:redis][:storage_type]}/redis"
bash "move-redis-dbs" do
  user "root"
  cwd "/"
  flags "-ex"
  code <<-EOF
    if [ -e #{node[:redis][:data_dir]}/* ]; then
    mv #{node[:redis][:data_dir]}/* /mnt/#{node[:redis][:storage_type]}/redis
    fi
EOF
  not_if "test -e /mnt/#{node[:redis][:storage_type]}/redis/#{node[:redis][:dumpdb_filename]}"
end

log "Deleting #{node[:redis][:data_dir]} to make symlink"
directory "#{node[:redis][:data_dir]}" do
  action :delete
  recursive true
end
 
log "linking /mnt/#{node[:redis][:storage_type]}/redis to #{node[:redis][:data_dir]}"
link "#{node[:redis][:data_dir]}" do
  to "/mnt/#{node[:redis][:storage_type]}/redis"
  link_type :symbolic
end

service "#{node[:redis][:service_name]}" do
  action :start
end
