marker "recipe_start"

class Chef::Recipe
  include GlusterFS::Tags
end
include_recipe "machine_tag::default"
# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.server_create_cluster.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
AUTH_ALLOW = node[:glusterfs][:server][:volume_auth]
IP_ADDR    = node[:cloud][:private_ips][0]
VOL_NAME = node[:glusterfs][:volume_name]
EXPORT_DIR = node[:glusterfs][:server][:storage_path]

Chef::Log.info "VOLUME INFORMATION:"
Chef::Log.info "~~~~~~~~~~~~~~~~~~~"
Chef::Log.info "Volume Name: #{VOL_NAME}"
Chef::Log.info "Volume Type: #{VOL_TYPE}"
Chef::Log.info "Replica Count: #{REPL_COUNT} " +
  "(only used for Replicated volumes)"

# Check if we already have a volume
sh = bash "Check existing volume" do
  code <<-EOF
    if ! gluster volume info  2>&1|grep -Gqx 'No volumes present'
    then
        echo "!!!> This host is already part of a volume!"
        echo
        gluster volume info
        echo
        echo "!!!> ABORTING"
        exit 1
    fi
  EOF
  action :nothing
end
sh.run_action(:run)

# Find all other spares so we can create a trusted pool
  find_all_spares "find_spares" do
    tags "#{TAG_SPARE}=true"
    secondary_tags "#{TAG_VOLUME}=#{VOL_NAME}"
  end#hosts_found=[]
#tags.each do |id, tags| 
#  Chef::Log.info "tags #{tags}"
#  hosts_found = tags["private_ips"].first
#end
## (sanity check)
#if hosts_found.empty?
#  raise "!!!> Didn't find any servers tagged with #{tags} " +
#    "and #{secondary_tags}"
#end
#
## Populate node attr
#node[:glusterfs][:server][:spares] = hosts_found
#Chef::Log.info "SPARES: #{node[:glusterfs][:server][:spares].inspect}"

# Consider replica_count for replicated volume types
# (maybe we can't use ALL the spares, since the number of bricks we need must
# be a factor of replica_count)
if VOL_TYPE == "Replicated"
  prune_spares "factor_by_replica_count" do
    replica_count REPL_COUNT
    myip IP_ADDR
  end
  #Chef::Log.info "PRUNED: #{node[:glusterfs][:server][:spares].inspect}"
end

log "Create a trusted pool from the IPs we have"
gluster_peer_probe "spares" do
  peers node[:glusterfs][:server][:spares]
end

log "Create a new volume from everyone's bricks"
ruby_block "Create volume" do
  block do
    require 'mixlib/shellout'
    Chef::Log.info "===> Creating volume #{VOL_NAME}"

    # Build the command...
    cmd = "gluster volume create #{VOL_NAME}"
    if VOL_TYPE == "Replicated"
      cmd += " replica #{REPL_COUNT}"
    end
    node[:glusterfs][:server][:spares].each do |ip|
      # FIXME query tags and use exact brick name from each host (theoretically
      # each server could have a unique export/brick name)
      cmd += " #{ip}:#{EXPORT_DIR}"
    end

    # Run the command
    Chef::Log.info "CMD: #{cmd}"
    result = ""
    brick=Mixlib::ShellOut.new("#{cmd}").run_command
    Chef::Log.info brick.stdout
    Chef::Log.info brick.stderr

    # Set some options on the volume
    Chef::Log.info "===> Configuring volume."
    SET_OPT = "gluster volume set #{VOL_NAME}"

    # FIXME should be glusterfs/server/volume_options input
    # FIXME check for successful output on these
    Chef::Log.info "setting auth.allow to #{AUTH_ALLOW}"
    system "#{SET_OPT} auth.allow '#{AUTH_ALLOW}' &>/dev/null"
    #Chef::Log.info "Setting nfs.disable on"
    #system "#{SET_OPT} nfs.disable on &>/dev/null"
    Chef::Log.info "Setting network.frame-timeout to 60"
    system "#{SET_OPT} network.frame-timeout 60 &>/dev/null"
    Chef::Log.info "Setting performance.cache-size to #{node[:glusterfs][:cache_size]}"
    system "#{SET_OPT} performance.cache-size #{node[:glusterfs][:cache_size]}"

    sleep 5   #Sleep for a bit so things sync up
    # Finally start the volume
    Chef::Log.info "===> Starting volume."
    result=Mixlib::ShellOut.new("gluster volume start #{VOL_NAME}").run_command
    Chef::Log.info "gluster volume start #{VOL_NAME} STDOUT: #{result.stdout}, STDERR:#{result.stderr}"

    Chef::Log.info "Volume Status"
    result=Mixlib::ShellOut.new("gluster volume status").run_command
    Chef::Log.info "STDOUT: #{result.stdout}\n STDERR: #{result.stderr}"

    Chef::Log.info "Volume Info"
    result=Mixlib::ShellOut.new("gluster volume info #{VOL_NAME}").run_command
    Chef::Log.info "STDOUT: #{result.stdout}\n STDERR: #{result.stderr}"

  end #block do
end #ruby_block do

rsc_remote_recipe "glusterfs::server_restart_gluster" do
  recipe "glusterfs::server_restart_gluster"
  recipient_tags  "glusterfs_server:volume=#{VOL_NAME}"
  action :run
end

## Remove TAG_SPARE from hosts and add TAG_ATTACH
#
# (the remote recipe being invoked is intelligent and only removes the tag if
# its brick is in fact part of the volume, thus safe to run on all hosts.)

rsc_remote_recipe "glusterfs::server_handle_tag_updates" do
  recipe "glusterfs::server_handle_tag_updates"
  recipient_tags "#{TAG_SPARE}=true"
  action :run
end

