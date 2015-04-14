name             "glusterfs"
maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Apache 2.0"
description      "GlusterFS recipes" 
version          "0.7.2"

depends "marker"
depends "apt"
depends "yum"
depends 'machine_tag', '~> 1.0.9'
depends 'rightscale_tag'
depends 'filesystem', '~> 0.9.0'
depends 'lvm', '~> 1.1.0'
depends 'rs-storage', '~> 1.0.3'
depends 'rsc_remote_recipe'

recipe "glusterfs::default", "Installs and configures the server."
#recipe "glusterfs::install", "Downloads and installs GlusterFS. Included in default"
#recipe "glusterfs::server_configure", "Configures glusterd, included in default"
#recipe "glusterfs::server_set_tags", "Adds 'glusterfs_server:*' tags so other servers can find us, included in default"
recipe "glusterfs::server_create_cluster", "Finds other servers tagged as 'spare=true' and initializes the GlusterFS volume" +
  " Run this on node one only after th server is operational"
recipe "glusterfs::server_join_cluster", "Finds an existing/joined GlusterFS server and request to be attached to the cluster."+
  " Run this on a new node joining the cluster or when restoring a failed node"
recipe "glusterfs::server_decommission", "Removes bricks from the volume, detaches from the cluster and resets some tags"
recipe "glusterfs::server_handle_probe_request", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_tag_updates", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_detach_request", "Remote recipe intended to be called by glusterfs::server_decommission"
#recipe "glusterfs::server_handle_live_migration", "Remote recipe intended to be called by glusterfs::server_live_migrate"
recipe "glusterfs::client_mount_volume", "Runs mount(8) with `-t glusterfs' option to mount glusterfs"
#recipe "glusterfs::server_live_migrate", "Live migrate a brick from one live node to another"
recipe "glusterfs::server_restart_gluster", "restart gluster"
recipe "glusterfs::volume_restore", "Restores the volume."
recipe "glusterfs::stripe_restore", "Restores the stripe volume."
#recipe "glusterfs::config_restored_volume_attrs", "sets volume attributes"
# TODO  Make an attribute with volume types choices (distributed, striped,
#       replicated, etc.) and use it in server_create_cluster accordingly.

attribute "glusterfs/version",
  :display_name => "Gluster Version",
  :description => "Gluster version to install, i.e. 3.5.1.",
  :required => "required",
  :recipes => [ "glusterfs::default", "glusterfs::client_mount_volume"]

attribute "glusterfs/server/volume_type",
  :display_name => "Volume Type",
  :description  => "The type of GlusterFS volume to create (distributed, replicated, etc)",
  :required     => "optional",
  :default      => "Replicated",
  :choice       => [ "Distributed", "Replicated" ],
  :recipes      => [ "glusterfs::default",
  "glusterfs::server_create_cluster",
  "glusterfs::server_join_cluster",
  "glusterfs::volume_restore" ]

attribute "glusterfs/server/volume_auth",
  :display_name => "Volume Auth",
  :description  => "The GlusterFS volume auth.allow to use (ex.: 172.*,10.*,173.*)",
  :required     => "optional",
  :default      => "*",
  :recipes      => [ "glusterfs::default",
  "glusterfs::server_create_cluster",
  "glusterfs::volume_restore" ]

attribute "glusterfs/volume_name",
  :display_name => "Volume Name",
  :description  => "The name of the GlusterFS volume. Servers are tagged with this name and trusted pools are keyed off this name, meaning everyone who shares the same name will become part of the same pool/volume",
  :required     => "required",
  :recipes      => [ "glusterfs::default",
  "glusterfs::server_create_cluster",
  "glusterfs::server_join_cluster",
  "glusterfs::client_mount_volume",
  "glusterfs::volume_restore",
  "glusterfs::stripe_restore" ]

attribute "glusterfs/server/storage_path",
  :display_name => "Storage Path",
  :description  => "The directory path to be used as a brick and added to the GlusterFS volume",
  :required     => "required",
  :recipes      => [ "glusterfs::default",
                       
  "glusterfs::server_create_cluster",
  "glusterfs::server_join_cluster",
  "glusterfs::stripe_restore" ]

attribute "glusterfs/server/replica_count",
  :display_name => "Replica Count",
  :description  => "The number of bricks to replicate files across for a Replicated volume type",
  :required     => "optional",
  :default      => "2",
  :recipes      => [ "glusterfs::default",
  "glusterfs::server_create_cluster",
  "glusterfs::server_join_cluster" ]

#attribute "glusterfs/server/replace_brick",
#    :display_name => "Replace Brick",
#    :description  => "Number of the brick to be replaced",
#    :required     => "optional",
#    :recipes      => [ "glusterfs::default",
#                       "glusterfs::server_live_migrate",
#                       "glusterfs::server_replace_brick" ]

#attribute "glusterfs/server/replace_brick_forced",
#    :display_name => "Force Brick Replace",
#    :description  => "Force brick replacement for dead node",
#    :required     => "optional",
#    :default      => "No",
#    :choice       => [ "No", "Yes" ],
#    :recipes      => [ "glusterfs::default",
#                       "glusterfs::server_live_migrate",
#                       "glusterfs::server_replace_brick" ]

attribute "glusterfs/client/mount_point",
  :display_name => "Mount point",
  :description  => "(Client only) The directory path where the GlusterFS volume should be mounted (e.g., /mnt/storage).",
  :type         => "string",
  :required     => "recommended",
  :default      => "/mnt/ephemeral/glusterfs",
  :recipes      => [ "glusterfs::default",
  "glusterfs::client_mount_volume" ]

attribute "glusterfs/client/mount_options",
  :display_name => "Mount Options",
  :description  => "(Client only) Extra options to be passed to the mount command",
  :required     => "optional",
  :recipes      => [ "glusterfs::default",
  "glusterfs::client_mount_volume" ]

attribute "glusterfs/cache_size",
  :display_name => "Gluster Performance Cache Size",
  :description => "Gluster Performance Cache Size.  Default is 32mb",
  :required => "optional",
  :recipes => [ "glusterfs::server_create_cluster" ]

