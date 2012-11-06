rightscale_marker :begin

remote_file "/tmp/mongodb.tar.gz" do
  source node[:mongo][:source]
  owner "root"
  group "root"
  mode "0644"
  action :create
end

user node[:mongo][:user] do
  action :create
end

directory node[:mongo][:install_dir] do
  owner node[:mongo][:user]
  group node[:mongo][:user]
  mode 0755
  recursive true
  action :create
end

bash "extract-mongo" do
  cwd "/"
  code <<-EOF
  tar -xzf /tmp/mongodb.tar.gz -C #{node[:mongo][:install_dir]} --strip-components=1
EOF
end

directory node[:mongo][:data_dir] do
  owner node[:mongo][:user]
  group node[:mongo][:user]
  mode 0755
  recursive true
  action :create
end

directory node[:mongo][:log_dir] do
  owner node[:mongo][:user]
  group node[:mongo][:user]
  mode 0755
  recursive true
  action :create
end

%w{mongo mongod mongodump mongoexport mongofiles mongoimport mongorestore mongos mongotop mongosniff mongostat}.each do |binary|
  link "/usr/bin/#{binary}" do
    to "#{node[:mongo][:install_dir]}/bin/#{binary}"
    link_type :symbolic
    action :create
  end
end

template "#{node[:mongo][:conf_file]}" do
  source "mongo.conf.erb"
  owner node[:mongo][:user]
  group node[:mongo][:user]
  mode 0777
  variables ( :db_path => node[:mongo][:data_dir] )
  action :create
end

template "/etc/init.d/#{node[:mongo][:service]}" do
  source "mongodb-init.erb"
  owner "root"
  group "root"
  mode "0777"
  variables ( :db_path => node[:mongo][:data_dir] )
  action :create
end

service node[:mongo][:service] do
  action [ :enable, :start ]
end

rightscale_marker :end
