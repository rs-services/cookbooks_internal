if node[:web_apache][:config_subdir].nil?
  Chef::Log.info "web_apache config_subdir nil, setting by file"
  case node[:platform]
  when "centos","redhat"
    Chef::Log.info "/etc/httpd found"
    config_subdir='httpd'
  when "debian","ubuntu"   
    Chef::Log.info "/etc/apache2 found"
    config_subdir='apache2'
  end
else
  Chef::Log.info "web_apache config_subdir found, setting to: #{node[:web_apache][:config_subdir]}"
  config_subdir=node[:web_apache][:config_subdir]
end

default[:apache_mod_header][:conf_file]="/etc/#{config_subdir}/mods-available/headers.conf"
default[:apache_mode_header][:headers]=Hash.new
Chef::Log.info "Headers Conf File: #{node[:apache_mod_header][:conf_file]}"
