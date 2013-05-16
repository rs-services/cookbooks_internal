rightscale_marker :begin

template "/etc/nginx/nginx.conf" do
  cookbook "nginx"
  source "nginx_lb.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(:worker_connections => node[:nginx][:configuration][:worker_connections],
            :port => node[:nginx][:configuration][:port],
            :root_dir => "/usr/share/nginx/html"
          )
  action :create
end

service "nginx" do
  action :restart
end

rightscale_marker :end
