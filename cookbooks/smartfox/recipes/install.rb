rightscale_marker :begin

bash "download_rpm" do
  code <<-EOM
    export STORAGE_ACCOUNT_ID="#{node[:repo][:default][:account]}"
    export STORAGE_ACCOUNT_SECRET="#{node[:repo][:default][:credential]}"
    /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:repo][:default][:repository]}" -s "#{node[:repo][:default][:prefix]}" -C "#{node[:repo][:default][:storage_account_provider]}" -d "#{Chef::Config[:file_cache_path]}/#{node[:repo][:default][:prefix]}"
  EOM
end

package "mc-smartfox-server" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:repo][:default][:prefix]}"
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
   :fqdn                => node[:cloud][:private_ips][0],
   :rmi_server_hostname => node[:smartfox][:rmi_server_hostname],
   :jmxremote_host      => node[:smartfox][:jmxremote_host]
  })
end

rightscale_marker :end
