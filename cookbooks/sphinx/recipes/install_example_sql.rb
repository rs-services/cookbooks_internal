package "mysql50-server" do
  action :install
end

package "mysql50" do
  action :install
end

service "mysqld" do
  action :start
end

cookbook_file "/tmp/example.sql" do
  source "example.sql"
  owner "root"
  group "root"
  mode "0644"
end

execute "mysql_import" do
  command "mysql -u root < /tmp/example.sql"
  action :run
end

execute "#{node[:spinx][:indexer]}" do
  command "#{node[:spinx][:indexer]} --all"
  action :run
end

service "#{node[:sphinx][:service]}" do
  action :start
end
