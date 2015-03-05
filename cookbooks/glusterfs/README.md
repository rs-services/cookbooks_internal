GlusterFS cookbook to work with RightScale

### Requirements
This cookbook depends on these other cookbooks
* marker
* apt
* yum
* machine_tag 
* rightscale_tag
* filesystem
* lvm
* rs-storage
* rsc_remote_recipe


### Recipes
* glusterfs::default - does the install and default configuration, run first
* glusterfs::server_create_cluster - Run on one server after the server is booted
* glusterfs::server_decommission - removes brink from cluster. put in decommion sequence
* glusterfs::server_join_cluster - puts server back in cluster
* glusterfs::volume_restore - Restores volume from backup/snapshot
* glusterfs::stripe_restore - restores stripe config from backup/snapshot

### Attributes
* node["gluster"]["version] - The version of gluster to install.  Default 3.5.2
* node["gluster"]["server"]["volume_type"] - The type of GlusterFS volume to create 
(distributed, replicated, etc)  Default: replicated
* node["gluster"]["volume_name"] - The name of the GlusterFS volume. Servers are 
tagged with this name and trusted pools are keyed off this name, meaning everyone 
who shares the same name will become part of the same pool/volume.  Default: Glusterfs
* node["gluster"]["server"]["storage_path"] - The directory path to be used as a brick 
and added to the GlusterFS volume. Default: /mnt/storage/glusterfs
* node["gluster"]["server"]["replica_count"] The number of bricks to replicate files 
across for a Replicated volume type.  Default 2 for two servers.  
* node["gluster"]["cache_size"] - Default: 32m 
* node["gluster"]["client"]["mount_point"] - (Client only) The directory path 
where the GlusterFS volume should be mounted Default: /mnt/ephemeral/gluster 
* node["gluster"]["client"]["mount_options"] - (Client only) Extra options to be passed to the mount command

### Usage to launch servers
* Add glusterfs::default to the runlist
* launch all serves in cluster
* run glusterfs::server_create_cluster on the first node, not the others.

### Mounting gluster volumes on client servers
* add glusterfs::client_mount_volume run list on your client server
* launch server(s)
