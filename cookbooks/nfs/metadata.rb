maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs/Configures nfs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.6"

%w{ ubuntu debian redhat centos scientific }.each do |os|
  supports os
end


recipe "nfs::server", "installs nfs server"
recipe "nfs::exports", "exports nfs share"
recipe "nfs::client", "installs and configures nfs client"
recipe "nfs::install_server_fw_rules", "opens nfs ports"

attribute "nfs/nfs_local_mount_point",
  :display_name => "NFS Local Mount Point",
  :description => "The local mount point on the nfs client",
  :default => "/mnt/nfs"
attribute "nfs/nfs_server",
  :display_name => "NFS Server", 
  :description => "ip or hostname of the nfs server",
  :default => ""
attribute "nfs/exports", 
  :display_name => "NFS exported dirs",
  :description => "comma separated list of dirs to export",
  :default => "/mnt"
