#Cookbook Name:: glusterfs
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# name of the GlusterFS volume we want to mount (Input)
VOL_NAME     = node[:glusterfs][:volume_name]

# how and where to mount it (Inputs)
MOUNT_OPTS   = node[:glusterfs][:client][:mount_options]
MOUNT_POINT  = node[:glusterfs][:client][:mount_point]

# tags to search for (Attributes)
TAG_VOLUME   = node[:glusterfs][:tag][:volume]

#Install fuse package
#
case node[:platform]
when 'centos','redhat'
  execute "create-yum-cache" do
    command "yum -q makecache"
    action :nothing
  end

  ruby_block "reload-internal-yum-cache" do
    block do
      Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
  end

  glusterfs "create repo" do
    version node[:glusterfs][:version]
    action :create_repo
  end
  

  package "fuse"
  package "glusterfs-fuse"
when 'ubuntu'
 apt_repository "glusterfs" do
   uri "http://ppa.launchpad.net/semiosis/glusterfs-3.2/ubuntu"
   components ["main"]
   distribution node['lsb']['codename']
   keyserver "keyserver.ubuntu.com"
   key "774BAC4D"
 end
 package "glusterfs-client"
else
  raise "Unsupported platform '#{node[:platform]}'"
end

# find all servers providing the volume we need
r = server_collection "glusterfs" do
  tags "#{TAG_VOLUME}=#{VOL_NAME}"
  action :nothing
end
r.run_action(:load)

# get the IP address of one of them (doesn't matter which one)
glusterfs_ip=""
r = ruby_block "Find Server IP" do
  block do
    node[:server_collection]["glusterfs"].each do |id, tags|
      ip_tag = tags.detect { |t| t =~ /^server:private_ip_0=/ }
      glusterfs_ip = ip_tag.gsub(/^.*=/, '')
      break   # just need one
    end
  end
  action :nothing
end
r.run_action(:create)

if glusterfs_ip.empty?
    raise "!!!> Didn't find any servers with tag #{TAG_VOLUME}=#{VOL_NAME}"
else
    log "===> Found GlusterFS server at #{glusterfs_ip}"
end

# load fuse module
bash "modprobe fuse" do
  code <<-EOF
    if modinfo fuse &>/dev/null; then
      if grep -q fuse /proc/modules; then
        echo "Fuse already loaded, skipping..."
      else
        echo "Fuse available but not loaded, running modprobe"
        modprobe fuse
      fi
    fi
  EOF
  #only_if "modinfo fuse &>/dev/null && ! grep -q fuse /proc/modules"
end

# create mount point
log "===> Creating mount point #{MOUNT_POINT}"
directory MOUNT_POINT do
  owner "root"
  group "root"
  mode "0755"
  recursive true
  action :create
end

# mount remote filesystem
log "===> Mounting GlusterFS volume"
bash "mount_glusterfs" do
  user "root"
  code <<-EOF
    opts=
    [ -n "#{MOUNT_OPTS}" ] && opts="-o #{MOUNT_OPTS}"
    mount -t glusterfs $opts #{glusterfs_ip}:/#{VOL_NAME} #{MOUNT_POINT} 
  EOF
  not_if "/bin/grep -qw '#{MOUNT_POINT}' /proc/mounts"
end

rightscale_marker :end

