rightscale_marker :begin

require 'digest/md5'

package "vsftpd" do
  action :install
end

user node[:vsftpd][:login] do
  comment "ftp user"
  uid 1000
  gid "users"
  shell "/bin/bash"
  password `openssl passwd -1 #{node[:vsftpd][:password]}`.strip
end

template "/etc/vsftpd/vsftpd.conf" do
  source "vsftpd.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  variables( :pasv_min_port => node['vsftpd']['pasv_min_port'],
             :pasv_max_port => node['vsftpd']['pasv_max_port'],
             :pasv_address => node[:cloud][:public_ips][0]
          )
  action :create
end

directory "/mnt/storage1/assets" do
  owner node[:vsftpd][:login]
  group "users"
  mode 0777
  recursive true
  action :create
end

link "/home/#{node[:vsftpd][:login]}/assets" do
  to "/mnt/storage1/assets"
  link_type :symbolic
  action :create
end

sys_firewall "20"
sys_firewall "21"

(node['vsftpd']['pasv_min_port'].to_i..node['vsftpd']['pasv_max_port'].to_i).each { |port| sys_firewall port.to_s }

service "vsftpd" do
  action [ :enable, :start ]
end

rightscale_marker :end
