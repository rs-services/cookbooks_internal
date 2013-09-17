default[:apache_mod_header][:conf_file]="/etc/#{node[:web_apache][:config_subdir]}/mods-available/headers.conf"
default[:apache_mode_header][:headers]=Hash.new
