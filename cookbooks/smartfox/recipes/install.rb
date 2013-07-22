rightscale_marker :begin

bash "download_rpm" do
  code <<-EOM
    export STORAGE_ACCOUNT_ID="#{node[:repo][:default][:account]}"
    export STORAGE_ACCOUNT_SECRET="#{node[:repo][:default][:credential]}"
    /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:repo][:default][:repository]}" -s "#{node[:repo][:default][:prefix]}" -C "#{node[:repo][:default][:storage_account_provider]}" -d "#{Chef::Config[:file_cache_path]}/#{node[:repo][:default][:prefix]}"
  EOM
end
  
rightscale_marker :end
