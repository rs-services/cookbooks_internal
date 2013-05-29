rightscale_marker :begin

include_recipe "nginx::install_#{node[:nginx][:install_type]}" 

directory "/etc/nginx" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

directory "/ncom/ncom_bin/conf.d" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/ncom/ncom_bin/nginx.conf" do
  cookbook "nginx"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:worker_connections => node[:nginx][:configuration][:worker_connections],
            :port => node[:nginx][:configuration][:port],
            :root_dir => "/usr/share/nginx/html",
            :root_files => "")
  action :create
end

template "/ncom/ncom_bin/fastcgi_params" do
  cookbook "nginx"
  source "fastcgi_params.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:fastcgi_params => node[:nginx][:fastcgi_params])
  action :create
end


directory "/var/log/nginx" do
  owner "root"
  group "root"
  mode 0755
  recursive true
  action :create
end

service "nginx" do
  supports :start => true, :stop => true, :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  persist true
end

sys_firewall node[:nginx][:configuration][:port] do
  action :update
end

rightscale_marker :end
