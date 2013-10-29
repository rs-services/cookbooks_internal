rightscale_marker :begin

bash "download_tgz" do
  code <<-EOM
    export STORAGE_ACCOUNT_ID="#{node[:smartfox][:storage_account_id]}"
    export STORAGE_ACCOUNT_SECRET="#{node[:smartfox][:storage_account_secret]}"
    /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:smartfox][:bucket]}" -s "#{node[:smartfox][:file]}" -C "#{node[:smartfox][:provider]}" -d "#{Chef::Config[:file_cache_path]}/#{node[:smartfox][:file].split('/').last}"
  EOM
end

bash "untar_smartfox" do
  code <<-EOM
    tar zxf "#{Chef::Config[:file_cache_path]}/#{node[:smartfox][:file].split('/').last}" -C /opt
    chown -R root:root /opt/SFSLS
  EOM
end

=begin
cookbook_file "/opt/SFS/Server/sfs" do
  source "sfs"
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end
=end

template "/opt/SFSLS/conf/wrapper.conf" do
  source "license-wrapper.erb"
  owner "root"
  group "root"
  variables({
   :rmi_server_hostname => node[:cloud][:private_ips][0],
   :jmxremote_host      => node[:cloud][:private_ips][0],
  })
end

bash "start_smartfox" do
  code <<-EOM
    /opt/SFSLS/sfsls start
  EOM
end

rightscale_marker :end
