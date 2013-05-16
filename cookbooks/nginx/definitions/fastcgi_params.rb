define :fastcgi_param, :update => true, :value => nil do
  node[:nginx][:fastcgi_params][params[:name]]=params[:value]
  
  template "/etc/nginx/fastcgi_params" do
    cookbook "nginx"
    source "fastcgi_params.erb"
    owner "root"
    group "root"
    mode 0644
    variables(:fastcgi_params => node[:nginx][:fastcgi_params])
    action :create
    notifies :restart, "service[nginx]", :delayed
  end

  service "nginx"
end
