action :set do
  node[:apache_mode_header][:headers][@new_resource.key]=@new_resource.value
  template "#{node[:apache_mod_header][:conf_file]}" do
    owner "root"
    group "root"
    mode "0644"
    variables( :headers => node[:apache_mode_header][:headers] )
    action :create
  end
 
  execute "a2enmod headers"
 
  service "#{node[:web_apache][:config_subdir]}" do
    action :restart
  end
end

