# These are the names of the RightScale tags used on the servers.  We define
# them here so we don't hardcode the names all throughout the code.
default_unless[:glusterfs][:tag][:spare]    = "glusterfs_server:spare"
default_unless[:glusterfs][:tag][:attached] = "glusterfs_server:attached"
default_unless[:glusterfs][:tag][:volume]   = "glusterfs_server:volume"
default_unless[:glusterfs][:tag][:brick]    = "glusterfs_server:brick"
default_unless[:glusterfs][:tag][:bricknum] = "glusterfs_server:bricknum"

default_unless[:glusterfs][:client][:mount_options] = ""
default_unless[:glusterfs][:server][:replica_count] = "2"
default_unless[:glusterfs][:server][:spares] = []
default_unless[:glusterfs][:server][:brick] = "0"
default_unless[:glusterfs][:server][:replace_brick] = ""

default[:glusterfs][:cache_size]="32MB"
default[:glusterfs][:version]='LATEST'

default[:glusterfs][:volume_name]="glusterfs"
default[:glusterfs][:server][:storage_path]="/mnt/ephemeral/glusterfs"
default[:glusterfs][:server][:peer_uuid_tag] = ""
  
case node[:platform_family] 
when "debian"
  default["glusterfs"]["servicename"]="glusterfs-server"
  default["glusterfs"]["version"] = '3.5.2'
when "rhel"
  default["glusterfs"]["version"] = "LATEST"
  default["glusterfs"]["servicename"]="glusterd"
end
