if node[:web_apache][:config_subdir].nil?
  if File.exists?('/etc/httpd')
    config_subdir='httpd'
  elsif File.exists?('/etc/apache2')
    config_subdir='apache2'
  end
else
  config_subdir=node[:web_apache][:config_subdir]
end

default[:apache_mod_header][:conf_file]="/etc/#{config_subdir}/mods-available/headers.conf"
default[:apache_mode_header][:headers]=Hash.new
Chef::Log.info "Headers Conf File: #{node[:apache_mod_header][:conf_file]}"
