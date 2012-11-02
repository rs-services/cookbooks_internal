rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
#
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
VOL_TYPE   = node[:glusterfs][:server][:volume_type]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i
IP_ADDR    = node[:cloud][:private_ips][0]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp

Chef::Log.info "VOLUME INFORMATION:"
Chef::Log.info "~~~~~~~~~~~~~~~~~~~"
Chef::Log.info "Volume Name: #{VOL_NAME}"
Chef::Log.info "Volume Type: #{VOL_TYPE}"
Chef::Log.info "Replica Count: #{REPL_COUNT} " +
               "(only used for Replicated volumes)"

# Check if we already have a volume
sh = bash "Check existing volume" do
  code <<-EOF
    if ! gluster volume info |grep -Gqx 'No volumes present'
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
end
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

# Create a trusted pool from the IPs we have
gluster_peer_probe "spares" do
  peers node[:glusterfs][:server][:spares]
end

# Create a new volume from everyone's bricks
ruby_block "Create volume" do
  block do
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
    result = ""
    IO.popen("#{cmd}") { |gl_io| result = gl_io.gets.chomp }
    if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
    end
    GlusterFS::Error.check(CMD_LOG, "Volume creation")

    # Set some options on the volume
    Chef::Log.info "===> Configuring volume."
    SET_OPT = "gluster volume set #{VOL_NAME}"

    # FIXME should be glusterfs/server/volume_options input
    # FIXME check for successful output on these
    system "#{SET_OPT} auth.allow '172.*,10.*' &>/dev/null"
    system "#{SET_OPT} nfs.disable on &>/dev/null"
    system "#{SET_OPT} network.frame-timeout 60 &>/dev/null"

    # Finally start the volume
    Chef::Log.info "===> Starting volume."
    result = ""
    IO.popen("gluster volume start #{VOL_NAME}") { |gl_io| result = gl_io.gets.chomp }
    if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
    end
    GlusterFS::Error.check(CMD_LOG, "Starting volume")

  end #block do
end #ruby_block do

## Remove TAG_SPARE from hosts and add TAG_ATTACH
#
# (the remote recipe being invoked is intelligent and only removes the tag if
# its brick is in fact part of the volume, thus safe to run on all hosts.)
log "===> Running remote recipes to update tags"
remote_recipe "update_tags" do
  recipe "glusterfs::server_handle_tag_updates"
  recipients_tags "#{TAG_SPARE}=true"
end
  
rightscale_marker :end
