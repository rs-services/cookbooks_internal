# Installs redis from packages
package "#{node[:redis][:package]}" do
  action :install
end

service "#{node[:redis][:service_name]}" do
  action :stop
end
