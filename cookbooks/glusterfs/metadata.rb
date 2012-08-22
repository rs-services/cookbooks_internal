maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Apache 2.0"
description      "GlusterFS recipes" 
version          "0.0.2"

depends "rightscale"
#depends "aria2"

recipe "glusterfs::default", "Currently unused"
recipe "glusterfs::install", "Downloads and installs GlusterFS"
recipe "glusterfs::server_configure", "Configures glusterd"
recipe "glusterfs::server_set_tags", "Adds 'glusterfs_server:*' tags so other servers can find us"
recipe "glusterfs::server_create_cluster", "Finds other servers tagged as 'spare=true' and initializes the GlusterFS volume"
recipe "glusterfs::server_join_cluster", "Finds an existing/joined GlusterFS server and request to be attached to the cluster"
recipe "glusterfs::server_decommission", "Removes bricks from the volume, detaches from the cluster and resets some tags"
recipe "glusterfs::server_handle_probe_request", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_tag_updates", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_detach_request", "Remote recipe intended to be called by glusterfs::server_decommission"
recipe "glusterfs::client_mount_volume", "Runs mount(8) with `-t glusterfs' option to mount glusterfs"

# TODO  Make an attribute with volume types choices (distributed, striped,
#       replicated, etc.) and use it in server_create_cluster accordingly.

#attribute "glusterfs/package_url",
#    :display_name => "Download URL",
#    :description  => "Direct URL to a GlusterFS package (override package manager)",
#    :required     => "optional",
#    #:default      => "https://rs-samsung-assets.s3.amazonaws.com/glusterfs%2Fglusterfs_3.2.6-1_amd64.deb",
#    :default      => "",
#    :recipes      => [ "glusterfs::install"]

attribute "glusterfs/volume_name",
    :display_name => "Volume Name",
    :description  => "The name of the exported volume on the GlusterFS server",
    :required     => "required",
    :recipes      => [ "glusterfs::server_set_tags",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster",
                       "glusterfs::client_mount_volume" ]

attribute "glusterfs/server/storage_path",
    :display_name => "Storage Path",
    :description  => "The directory path to be used as a brick and added to the GlusterFS volume",
    :required     => "required",
    :recipes      => [ "glusterfs::server_set_tags",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster" ]

attribute "glusterfs/server/replica_count",
    :display_name => "Replica Count",
    :description  => "The directory path to be added to the volume as a brick",
    :required     => "optional",
    :default      => "1",
    :recipes      => [ "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster" ]

attribute "glusterfs/client/mount_point",
    :display_name => "Mount point",
    :description => "(Client only) The directory path where the GlusterFS volume should be mounted (e.g., /mnt/storage).",
    :type => "string",
    :required => "recommended",
    :default => "/mnt/ephemeral/glusterfs",
    :recipes => [ "glusterfs::client_mount_volume"]

attribute "glusterfs/client/mount_options",
    :display_name => "Mount Options",
    :description  => "(Client only) Extra options to be passed to the mount command",
    :required     => "optional",
    :recipes      => [ "glusterfs::client_mount_volume"]

