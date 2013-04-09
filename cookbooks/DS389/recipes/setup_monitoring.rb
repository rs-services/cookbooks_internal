package "389-ds-base-devel" do
  action :install
end

gem_package "rdoc" do 
  gem_binary "/usr/bin/gem"
  action :install
end

gem_package "ruby-ldap" do
  gem_binary "/usr/bin/gem"
  action :install
end

template "/usr/local/bin/ldap.rb" do
  source "ldap.rb.erb"
  owner "root"
  group "root"
  mode "0777"
  action :create
end

template "/etc/collectd.d/ldap.conf" do
  source "ldap.conf.erb"
  owner "root"
  group "root"
  mode "0777"
  action :create
end

service "collectd" do
  action :restart
end
