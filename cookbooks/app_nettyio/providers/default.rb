#
# Cookbook Name:: nettyio
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# Stop app
#action :stop do
#  log "  Running stop sequence"
#  service "nettyio" do
#    action :stop
#    persist false
#  end
#end

action :stop do
  log "  Running stop sequence"
  execute "stopping server" do
    command "/etc/init.d/nettyio stop"
    action :run
  end
end

# Start app
action :start do
  log "  Running start sequence"
  execute "stopping server" do
    command "/etc/init.d/nettyio start"
    action :run
  end
end


# Restart nettyio
action :restart do
  action_stop
  sleep 5
  action_start
end

# Install Nettyio
action :install do
  directory "#{node[:app_nettyio][:install_dir]}/jars" do
    recursive true
    action :create
  end

  cookbook_file "#{node[:app_nettyio][:install_dir]}/jars/netty-#{node[:app_nettyio][:version]}.Final.jar" do
    source "netty-#{node[:app_nettyio][:version]}.Final.jar"
    mode "0644"
    cookbook "app_nettyio"
  end


  template "/etc/init.d/nettyio" do
    source "nettyio.rc.erb"
    mode 0744
    variables(:java_home=>node[:java][:home],
      :version=>node[:app_nettyio][:version], 
      :install_dir=>node[:app_nettyio][:install_dir], 
      :main_class=>node[:app_nettyio][:main_class],
      :destination=>node[:app][:destination],
      :java_xms => node[:app_nettyio][:java][:xms],
      :java_xmx => node[:app_nettyio][:java][:xmx],
      :java_permsize => node[:app_nettyio][:java][:permsize],
      :java_maxpermsize => node[:app_nettyio][:java][:maxpermsize],
      :java_newsize => node[:app_nettyio][:java][:newsize],
      :java_maxnewsize => node[:app_nettyio][:java][:maxnewsize]
    )
    cookbook "app_nettyio"
  end

  service "nettyio" do
    supports :status => true, :restart => true, :reload => false ,:stop=>true, :start=>true
    action :enable
  end

  template "/root/.profile" do
    source "profile.erb"
    variables(:java_home=>node[:java][:home])
    cookbook "app_nettyio"
  end
  
  #remove sun jdk on centos
  #ubuntu doesn't have java preinstalled.
  node[:app][:uninstall_packages].each do |p|
    log "   removing #{p}"
    package p do
      action :remove
    end
  end

  node[:app][:packages].each do |p|
    log "   installing #{p}"
    package p
  end
end


# Setup apache virtual host and corresponding tomcat configs
action :setup_vhost do
  log "setup_vhost is not implemented"
end
# Setup project db connection
action :setup_db_connection do
  log "setup_db_connection is not implemented"
end

# Setup monitoring tools for tomcat
action :setup_monitoring do
  log "setup_monitoring is not implemented"
end

# Download/Update application repository
action :code_update do

  deploy_dir = new_resource.destination

  log "  Starting code update sequence"
  log "  Current project doc root is set to #{deploy_dir}"
  log "  Downloading project repo"

  # Calling "repo" LWRP to download remote project repository
  repo "default" do
    destination deploy_dir
    action node[:repo][:default][:perform_action].to_sym
    app_user 'root'
    repository node[:repo][:default][:repository]
    persist false
  end

  # Restarting apache
  action_restart

end
