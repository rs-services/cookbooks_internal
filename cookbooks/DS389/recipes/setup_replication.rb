#configure replication
#
rightscale_marker :begin

right_link_tag "directory_replication:status=master"
right_link_tag "directory:hostname=#{node[:DS389][:Hostname]}"

directory "/tmp/replication" do
  owner "root"
  group "root"
  mode "0644"
  action :create
end

template "/tmp/replication/changelog.ldif" do
  source "replication_changelog.ldif.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :admin_domain => node[:DS389][:AdminDomain] )
  action :create
end

execute "ldapadd -D \"cn=Directory Manager\" -w #{node[:DS389][:RootDNPwd]} -f /tmp/replication/changelog.ldif"

template "/tmp/replication/user.ldif" do
  source "replication_user.ldif.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "ldapadd -D \"cn=Directory Manager\" -w #{node[:DS389][:RootDNPwd]} -f /tmp/replication/user.ldif"

suffix_str=""
node[:DS389][:AdminDomain].split('.').each_with_index do |domain,i|
  suffix_str+="dc=#{domain}"
  suffix_str+="," unless i == (node[:DS389][:AdminDomain].split('.').length - 1)
end

replica_id=rand(65534)
right_link_tag "directory_replication:id=#{replica_id}"

template "/tmp/replication/supplier.ldif" do
  source "replication_supplier.ldif.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(:replica_id => replica_id,
            :suffix => suffix_str )
  action :create
end

execute "ldapmodify -D \"cn=Directory Manager\" -w #{node[:DS389][:RootDNPwd]} -f /tmp/replication/supplier.ldif"

rightscale_marker :end
