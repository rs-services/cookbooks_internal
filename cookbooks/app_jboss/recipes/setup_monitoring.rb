rightscale_marker :begin

install_target = "/usr/local/jboss"

log "  Setup of collectd monitoring for jboss"

# Installing and configuring collectd plugin for JVM monitoring.
# Using the same plugin, which already present in app_tomcat cookbook.
cookbook_file "/usr/share/java/collectd.jar" do
	source "collectd.jar"
	mode "0644"
	cookbook "app_tomcat"
end

# Linking collectd
link "#{install_target}/lib/collectd.jar" do
	to "/usr/share/java/collectd.jar"
end

# Add collectd support to run.conf
bash "Add collectd to run.conf" do
	flags "-ex"
	code <<-EOH
			cat <<'EOF'>>"#{install_target}/bin/run.conf"
JAVA_OPTS="\$JAVA_OPTS -Djcd.host=#{node[:rightscale][:instance_uuid]} -Djcd.instance=jboss -Djcd.dest=udp://#{node[:rightscale][:servers][:sketchy][:hostname]}:3011 -Djcd.tmpl=javalang -javaagent:#{install_target}/lib/collectd.jar"
EOF
			EOH
end

# Installing and configuring collectd plugin for JBoss monitoring.
cookbook_file "/tmp/collectd-plugin-java.tar.gz" do
	source "collectd-plugin-java.tar.gz"
	mode "0644"
	cookbook "app_jboss"
end

# Extracting the plugin
bash "Extracting the plugin" do
	flags "-ex"
	code <<-EOH
		tar xzf /tmp/collectd-plugin-java.tar.gz -C /
	EOH
end

cookbook_file "#{node[:rightscale][:collectd_plugin_dir]}/GenericJMX.conf" do
	action :create
	source "GenericJMX.conf"
	mode "0644"
	cookbook "app_jboss"
	notifies :restart, resources(:service => "collectd")
end

rightscale_marker :begin
