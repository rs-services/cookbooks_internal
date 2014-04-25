remote_file "#{node[:rightscale_services_tools][:cacert]}" do
  source "http://curl.haxx.se/ca/cacert.pem"
  owner "root"
  group "root"
  mode "0644"
  action :create
end
