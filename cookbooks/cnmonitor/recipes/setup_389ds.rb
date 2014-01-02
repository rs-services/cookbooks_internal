#http://port389.org/wiki/Howto:CN%3DMonitor_LDAP_Monitoring
rightscale_marker :begin

%w{openldap-clients httpd mod_ssl openssl php php-cli php-ldap php-gd mysql mysql-server}.each { |pkg|
  package pkg do
    action :install
  end
}

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/openldap/ldap.conf")
    file.insert_line_if_no_match("/TLS_REQCERT  never/", "TLS_REQCERT  never")
    file.write_file
  end
end

remote_file "/tmp/cnmonitor-3.2.1-1.noarch.rpm" do
  source "http://ps-cf.rightscale.com/cnmonitor/cnmonitor-3.2.1-1.noarch.rpm"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

package "cnmonitor" do
  source "/tmp/cnmonitor-3.2.1-1.noarch.rpm"
  provider Chef::Provider::Package::Rpm
  action :install
end

service "mysqld" do
  action :start
end

execute "mysql -u root < /usr/share/cnmonitor/sql/mysql.sql"

template "/etc/cnmonitor/config.xml" do
  source "config.xml.erb"
  owner "root"
  group "apache"
  mode "0664"
  action :create
end

template "/var/www/html/index.html" do
  source "index.html.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

cron "collectdb" do
  minute "30"
  home "/usr/share/cnmonitor/bin"
  command "php collectdb.php"
  action :create
end

cron "collectservermessage" do
  minute "10"
  home "/usr/share/cnmonitor/bin"
  command "php collectservermessage.php"
  action :create
end

cron "collectsummary" do
  minute "0"
  hour "4"
  home "/usr/share/cnmonitor/bin"
  command "php collectsummary.php"
  action :create
end

template "/tmp/monitor.ldif" do
  source "user_monitor.cnmonitor.ldif.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "ldapadd -D \"cn=directory manager\" -w #{node[:DS389][:RootDNPwd]} -f /tmp/monitor.ldif"

template "/tmp/aci.ldif" do
  source "aci.ldif.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "ldapmodify -D \"cn=directory manager\" -w #{node[:DS389][:RootDNPwd]} -f /tmp/aci.ldif"

service "httpd" do
  action :restart
end

rightscale_marker :end
