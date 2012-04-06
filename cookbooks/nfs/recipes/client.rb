#installs nfs client and configure a single mount"

include_recipe "nfs"

package "nfs-utils" do
  action :install
end

directory node[:nfs][:nfs_local_mount_point] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

node[:nfs][:exports].split(",").each do |target|
  directory "#{node[:nfs][:nfs_local_mount_point]}#{target}" do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
  mount "#{node[:nfs][:nfs_local_mount_point]}#{target}" do
    fstype "nfs"
    options %w(rw,soft,intr,nfsvers=3)
    device "#{node[:nfs][:nfs_server]}:#{target}"
    dump 0
    pass 0
    action [:mount]
  end
end
