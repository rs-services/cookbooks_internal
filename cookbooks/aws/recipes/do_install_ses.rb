rightscale_marker :begin

package "postfix" do 
  action :install
end

package "ssmtp" do
  action :remove
end

package "procmail" do
  action :install
end

package "perl" do
  action :install
end

template "/etc/postfix/main.cf" do 
  source "main.cf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :hostname => node[:hostname],
             :domain => node[:aws][:ses][:domain] )
  action :create
end

file "/etc/postfix/sasl_passwd" do
  backup false
  action :nothing
end

execute "postmap hash:/etc/postfix/sasl_passwd" do
  action :nothing
  notifies :delete, "file[/etc/postfix/sasl_passwd]", :immediately
end

template "/etc/postfix/sasl_passwd" do
  owner "root"
  group "root"
  mode "0644"
  variables( :username => node[:aws][:ses][:username],
              :password => node[:aws][:ses][:password])
  action :create
  notifies :run, "execute[postmap hash:/etc/postfix/sasl_passwd]", :immediately
end

service "postfix" do
  action :restart
end

execute "alternatives --auto mta"

rightscale_marker :end

