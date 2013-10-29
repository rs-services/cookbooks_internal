rightscale_marker :begin

bash "download_rpm" do
  code <<-EOM
    export STORAGE_ACCOUNT_ID="#{node[:smartfox][:storage_account_id]}"
    export STORAGE_ACCOUNT_SECRET="#{node[:smartfox][:storage_account_secret]}"
    /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:smartfox][:bucket]}" -s "#{node[:smartfox][:file]}" -C "#{node[:smartfox][:provider]}" -d "#{Chef::Config[:file_cache_path]}/#{node[:smartfox][:file].split('/').last}"
  EOM
end

package "mc-smartfox-server" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:smartfox][:file].split('/').last}"
  provider Chef::Provider::Package::Rpm
end

link "/opt/SFS" do
  to "/opt/SFS_PRO_1.6.9"
end

cookbook_file "/opt/SFS/Server/sfs" do
  source "sfs"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

template "/opt/SFS/Server/conf/wrapper.conf" do
  source "sfs-wrapper.erb"
  owner "root"
  group "root"
  variables({
   :rmi_server_hostname => node[:cloud][:private_ips][0],
   :jmxremote_host      => node[:cloud][:private_ips][0],
  })
end

template "/opt/SFS/Server/config.xml" do
  source "config-#{node[:smartfox][:tier]}.xml.erb"
  owner "root"
  group "root"
  mode "0444"
  variables({
   :license_server => node[:smartfox][:license_server],
   :license_number => node[:smartfox][:license_number]
  })
end

if "#{node[:smartfox][:tier]}".eql?("anagrammagic")
  template "/opt/SFS/Server/AnagrammagicZone.xml" do
    source "AnagrammagicZone.xml.erb"
    owner "root"
    group "root"
    mode "0444"
    variables({
      :bullfrog_poker_db_host => node[:smartfox][:bullfrog_poker_db_host],
      :hostname               => node[:smartfox][:hostname]
    })
  end
end

if %w(5inarow anagrammagic boxo poker).include? node[:smartfox][:tier]
  template "/opt/SFS/Server/LobbyExtensionSetup.xml" do
    source "LobbyExtensionSetup-#{node[:smartfox][:tier]}.xml.erb"
    owner "root"
    group "root"
    mode "0444"
    variables({
      :bullfrog_poker_db_host  => node[:smartfox][:bullfrog_poker_db_host],
      :bullfrog_poker_username => node[:smartfox][:bullfrog_poker_username],
      :bullfrog_poker_password => node[:smartfox][:bullfrog_poker_password],
      :hostname                => node[:smartfox][:hostname],
      :serpent_endpoint        => node[:smartfox][:serpent_endpoint]
    })
  end
end

if node[:smartfox][:tier].eql?("discpool")
  template "/opt/SFS/Server/conf/MiniclipCouronne.conf" do
    source "MiniclipCouronne.conf.erb"
    owner "root"
    group "root"
    mode "0444"
    variables({
      :discpool_load_balancer_dns_name => node[:smartfox][:discpool_load_balancer_dns_name],
      :bullfrog_poker_db_host => node[:smartfox][:bullfrog_poker_db_host],
      :bullfrog_poker_password => node[:smartfox][:bullfrog_poker_password]
    })
  end
end

if node[:smartfox][:tier].eql?("discpool")
  template "/opt/SFS/Server/conf/MiniclipCouronneLobby.conf" do
    source "MiniclipCouronneLobby.conf.erb"
    owner "root"
    group "root"
    mode "0444"
  end
end

bash "untar_javaextensions" do
  code <<-EOM
   export STORAGE_ACCOUNT_ID="#{node[:smartfox][:storage_account_id]}"
   export STORAGE_ACCOUNT_SECRET="#{node[:smartfox][:storage_account_secret]}"
   /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:smartfox][:bucket]}" -s "smartfox-games-dump/javaExtensions-#{node[:smartfox][:tier]}.tar" -C "#{node[:smartfox][:provider]}" -d "#{Chef::Config[:file_cache_path]}/javaExtensions-#{node[:smartfox][:tier]}.tar"
   tar xf "#{Chef::Config[:file_cache_path]}/javaExtensions-#{node[:smartfox][:tier]}.tar" -C /opt/SFS/Server
   chown -R root:root /opt/SFS/Server/javaExtensions
  EOM
end

bash "install_mysql_connector_jar" do
  code <<-EOM
    export STORAGE_ACCOUNT_ID="#{node[:smartfox][:storage_account_id]}"
    export STORAGE_ACCOUNT_SECRET="#{node[:smartfox][:storage_account_secret]}"
    /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:smartfox][:bucket]}" -s "smartfox-games-dump/mysql-connector-java-5.1.12-bin.jar" -C "#{node[:smartfox][:provider]}" -d "#{Chef::Config[:file_cache_path]}/mysql-connector-java-5.1.12-bin.jar"
    cp "#{Chef::Config[:file_cache_path]}/mysql-connector-java-5.1.12-bin.jar" /opt/SFS/jre/lib/ext/
    chmod 444 /opt/SFS/jre/lib/ext/mysql-connector-java-5.1.12-bin.jar
    chown root:root /opt/SFS/jre/lib/ext/mysql-connector-java-5.1.12-bin.jar
  EOM
end

bash "start_smartfox" do
  code <<-EOM
    /opt/SFS/Server/sfs start
  EOM
end

rightscale_marker :end
