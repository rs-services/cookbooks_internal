#configure replication
#
rightscale_marker :begin

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

rightscale_marker :end
