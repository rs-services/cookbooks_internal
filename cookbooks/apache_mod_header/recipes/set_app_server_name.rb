rightscale_marker :begin

apache_mod_header "AppServerName" do
  value node[:apache_mod_header][:app_server_name]
  action :set
end

rightscale_marker :end
