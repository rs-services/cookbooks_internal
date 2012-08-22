default_unless[:glusterfs][:client][:mount_options] = ""

default_unless[:glusterfs][:tag][:spare]    = "glusterfs_server:spare"
default_unless[:glusterfs][:tag][:attached] = "glusterfs_server:attached"
default_unless[:glusterfs][:tag][:volume]   = "glusterfs_server:volume"
default_unless[:glusterfs][:tag][:brick]    = "glusterfs_server:brick"
