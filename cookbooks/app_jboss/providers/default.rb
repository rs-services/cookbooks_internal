#
# Cookbook Name:: app_jboss
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# Start jboss service
action :start do
  log "Running start sequence"
  service "jboss" do
    action :start
    persist false
  end
end

# Stop jboss service
action :stop do
  log "Running stop sequence"
  service "jboss" do
    action :stop
    persist false
  end
end

# Restart jboss service
action :restart do
  log "Running restart sequence"
  service "jboss" do
    action :restart
    persist false
  end
end

# Install JBoss 
action :install do

  log "Creating JBoss user and group ..."

  group "jboss"

  user "jboss" do
    home "/usr/local/jboss"
    group "jboss"
  end

  log "Downloading JBoss ..."

  remote_file "/tmp/jboss.tar.gz" do
    owner "root"
    group "root"
    mode "0644"
    source "#{node[:app_jboss][:source]}"
    checksum "#{node[:app_jboss][:source_sha256]}"
  end

  log "Unpacking JBoss ..."

  bash "untar_jboss" do
    cwd "/tmp"
    code <<-EOM
      mkdir /usr/local/jboss
      tar zxf jboss.tar.gz --strip=1 -C /usr/local/jboss
      chown -R jboss:jboss /usr/local/jboss
      chmod 0755 /usr/local/jboss
      rm -f /usr/local/jboss/bin/*.bat
      rm -f /usr/local/jboss/standalone/configuration/*.xml
    EOM
    not_if { ::File.exists?("/usr/local/jboss/bin") }
  end

  template "/usr/local/jboss/standalone/configuration/mgmt-users.properties" do
    source "mgmt-users.properties.erb"
    owner "jboss"
    group "jboss"
    cookbook "app_jboss"
    variables({
      :management_user     => node[:app_jboss][:management_user],
      :management_password => Digest::MD5.hexdigest(node[:app_jboss][:management_password])
    })
  end

  template "/usr/local/jboss/domain/configuration/mgmt-users.properties" do
    source "mgmt-users.properties.erb"
    owner "jboss"
    group "jboss"
    cookbook "app_jboss"
    variables({
      :management_user     => node[:app_jboss][:management_user],
      :management_password => Digest::MD5.hexdigest(node[:app_jboss][:management_password])
    })
  end

  log "Installing JBoss init and config files ..."

  template "/usr/local/jboss/standalone/configuration/standalone-ha.xml" do
    source "standalone-ha.xml.erb"
    owner "jboss"
    group "jboss"
    cookbook "app_jboss"
    variables({
      :jboss_bind_address    => node[:app_jboss][:bind_address],
      :jboss_http_bind_port  => node[:app_jboss][:http_bind_port],
      :jboss_https_bind_port => node[:app_jboss][:https_bind_port]
    })
  end

  directory "/etc/jboss-as" do
    owner "root"
    group "root"
    mode "0755"
  end

  cookbook_file "/etc/jboss-as/jboss-as.conf" do
    owner "root"
    group "root"
    mode "0644"
    cookbook "app_jboss"
    action :create_if_missing
  end

  cookbook_file "/etc/init.d/jboss" do
    source "jboss-as-standalone.sh"
    owner "root"
    group "root"
    mode "0755"
    cookbook "app_jboss"
    action :create_if_missing
  end
end # END :install

# TODO: 
action :setup_monitoring do
  log "SETUP MONITORING NOT IMPLEMENTED YET"
end

=begin
# Configure JBoss monitoring
action :setup_monitoring do

  log "Configuring collectd monitoring for JBoss ..."

  # Installing and configuring collectd plugin for JVM monitoring.
  cookbook_file "/usr/share/java/collectd.jar" do
    source "collectd.jar"
    owner "root"
    group "root"
    mode "0644"
    cookbook "app_jboss"
  end

  # Linking collectd
    link "/usr/local/jboss/lib/collectd.jar" do
    to "/usr/share/java/collectd.jar"
    not_if { !::File.exists?("/usr/share/java/collectd.jar") }
  end

# TODO: I think this is supposed to be written to jboss/bin/standalone.conf.
# Also this code should be using a template. I will correct it soon.
  # Add collectd support to run.conf
  bash "Add collectd to run.conf" do
    flags "-ex"
    code <<-EOH
      cat <<'EOF'>>"/usr/local/jboss/bin/run.conf"
JAVA_OPTS="\$JAVA_OPTS -Djcd.host=#{node[:rightscale][:instance_uuid]} -Djcd.instance=jboss -Djcd.dest=udp://#{node[:rightscale][:servers][:sketchy][:hostname]}:3011 -Djcd.tmpl=javalang -javaagent:#{install_target}/lib/collectd.jar"
EOF
    EOH
  end

  # Installing and configuring collectd plugin for JBoss monitoring.
  cookbook_file "/tmp/collectd-plugin-java.tar.gz" do
    source "collectd-plugin-java.tar.gz"
    mode "0644"
    owner "root"
    group "root"
    cookbook "app_jboss"
  end

  # Extracting the plugin
  bash "Extracting the plugin" do
    flags "-ex"
    code <<-EOM
      tar xzf /tmp/collectd-plugin-java.tar.gz -C /
    EOM
  end

  cookbook_file "#{node[:rightscale][:collectd_plugin_dir]}/GenericJMX.conf" do
    source "GenericJMX.conf"
    owner "root"
    group "root"
    mode "0644"
    cookbook "app_jboss"
    action :create
    notifies :restart, resources(:service => "collectd")
  end
end # END :setup_monitoring
=end

action :code_update do
  deploy_dir = new_resource.destination

  log "Starting code update sequence"
  log "Current project doc root is set to #{deploy_dir}"
  log "Downloading project repo"

  # Calling "repo" LWRP to download remote project repository
  # See cookbooks/repo/resources/default.rb for the "repo" resource.
  repo "default" do
    destination deploy_dir
    action node[:repo][:default][:perform_action].to_sym
    app_user node[:app][:user]
    repository node[:repo][:default][:repository]
    persist false
  end
end

action :setup_db_connection do
  log "Downloading MySQL Connector ..."

  remote_file "/tmp/mysql_connector.tar.gz" do
    source "#{node[:app_jboss][:source_mysql_connector]}"
    owner "root"
    group "root"
    mode "0644"
  end

  log "Configuring MySQL Connector ..."

  bash "untar_mysql_connector" do
    cwd "/tmp"
    code <<-EOM
      mkdir /usr/local/jboss/mysql-connector
      tar zxf mysql_connector.tar.gz --strip=1 -C /usr/local/jboss/mysql-connector
      mkdir -p /usr/local/jboss/modules/com/mysql/main
      cp /usr/local/jboss/mysql-connector/mysql-connector-java-5.1.25-bin.jar /usr/local/jboss/modules/com/mysql/main
      chown -R jboss:jboss /usr/local/jboss
    EOM
  end

  cookbook_file "/usr/local/jboss/modules/com/mysql/main/module.xml" do
    source "module.xml"
    owner "jboss"
    group "jboss"
    mode "0644"
    cookbook "app_jboss"
  end
end

# TODO:
action :setup_vhost do
  log "Add :setup_vhost code here ..."
end
