#
# Cookbook Name:: app_nginx_php
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# Stop apache
action :stop do
  log " Running stop sequence - `pgrep nginx`"
  #service "nginx" do
    #action :start
    #persist false
  #end
  bash "stop_service" do
    code <<-EOH
      service nginx stop
    EOH
  end
end

# Start apache
action :start do
  log " Running start sequence"
  #service "nginx" do
  #  action :start
  #  persist false
  #end
  bash "stop_service" do
    code <<-EOH
      service nginx start
    EOH
  end

  log "NGINX started - `pgrep nginx`"
end

# Reload apache
action :reload do
  log " Running reload sequence"
  service "nginx" do
    action :reload
    persist false
  end
end

# Restart apache
action :restart do
  action_stop
  sleep 5
  action_start
end

# Download/Update application repository
action :code_update do

  deploy_dir = new_resource.destination

  log " Starting code update sequence"
  log " Current project doc root is set to #{deploy_dir}"
  log " Downloading project repo"

  # Calling "repo" LWRP to download remote project repository
  repo "default" do
    destination deploy_dir
    action node[:repo][:default][:perform_action].to_sym
    app_user node[:app_php][:app_user]
    repository node[:repo][:default][:repository]
    persist false
  end

  # Restarting apache
  action_restart

end

action :setup_db_connection do
  project_root = new_resource.destination
  log "Client setup db connection"

end

action :install do
  log "nginx installed" 
end

action :setup_vhost do
  vhost_dir=new_resource.destination
  vhost_port=new_resource.port
  action_stop

  fastcgi_params "ENVIRONMENT" do
    value node[:application][:environment]}
    action :update
  end

  template "/etc/nginx/nginx.conf" do
    cookbook "nginx"
    source "nginx.conf.erb"
    owner "root"
    group "root"
     mode 0644
    variables(:worker_connections => node[:nginx][:configuration][:worker_connections],
              :port => vhost_port,
              :root_dir => ::File.join(vhost_dir,'htdocs'),
              :root_files => "index.php default.php",
              :php_fpm => node[:app][:php_fpm]
             )
    action :create
  end
  sys_firewall vhost_port
  action_start
end

