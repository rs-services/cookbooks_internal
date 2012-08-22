rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

# Constants as shortcuts for attributes
TAG_SPARE  = node[:glusterfs][:tag][:spare]
VOL_NAME   = node[:glusterfs][:volume_name]
EXPORT_DIR = node[:glusterfs][:server][:storage_path]
REPL_COUNT = node[:glusterfs][:server][:replica_count].to_i

# find all servers marked as 'spares'
server_collection "glusterfs" do
  tags "#{TAG_SPARE}=true"
end

ruby_block "Probe spares and create volume" do
  block do
    hosts_found = []
    # grab IPs of the spares
    node[:server_collection]["glusterfs"].each do |id, tags|
      ip_tag = tags.detect { |i| i =~ /^server:private_ip_0=/ }
      ip = ip_tag.gsub(/^.*=/, '')
      Chef::Log.info "===> Found server #{ip}"
      hosts_found << ip
    end

    if hosts_found.empty?
      raise "!!!> Didn't find any servers tagged with #{TAG_SPARE}=true"
    end

    # Probe each IP to attach as peer
    hosts_found.each do |ip|
      if ip == node[:cloud][:private_ips][0] # skip ourself
        Chef::Log.info "===> Skipping myself (#{ip})"
        next
      end

      # first check if peer is already connected!
      # (If he is already connected, it's probably from a previous failure of
      # this recipe since he's still marked as spare)
      peered = false
      begin
        Chef::Log.info "===> Checking if #{ip} is already peered"
        output = IO.popen("gluster peer status")
        output.readlines.each do |line|
          if (line.chomp =~ /^Hostname:\s+#{Regexp.escape(ip)}$/)
            Chef::Log.info "===>  + already peered!? skipping host"
            peered = true  # skip this host we already know about him somehow
            break
          end
        end
      rescue => e
        raise "`gluster peer status' failed: #{e.message}"
      end

      # send the probe
      if ! peered
        Chef::Log.info "===>  - not peered, sending probe command"
        system "gluster peer probe #{ip} &> #{CMD_LOG}"
        GlusterFS::Error.check(CMD_LOG, "Adding #{ip} to cluster")
      end
    end

    # The replication count determines what number of bricks you need when
    # adding to- or removing from the volume.
    # Do we have enough hosts to meet this number?
    if (hosts_found.size < REPL_COUNT)
        raise "!!!> Didn't find enough servers with tag #{TAG_SPARE}=true to satisfy a replication count of #{REPL_COUNT}."
    end

    remainder = hosts_found.size % REPL_COUNT
    if (remainder != 0)
        Chef::Log.info "WARN: Not all spares will be used. Number not divisible by replication count '#{REPL_COUNT}'."
    end

    max_usable = hosts_found.size-remainder

    # Create a new volume from bricks
    Chef::Log.info "===> Creating volume #{VOL_NAME}"

    cmd = "gluster volume create #{VOL_NAME} transport tcp"
    # gluster will bark if you configure a replica count of '1'
    if REPL_COUNT > 1
      cmd += " replica #{REPL_COUNT}"
    end

    hosts_found.each_with_index do |ip, idx|
      cmd += " #{ip}:#{EXPORT_DIR}"
      break if idx == (max_usable-1)  # 0-based index
    end
    system "#{cmd} &> #{CMD_LOG}"
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
    system "gluster volume start #{VOL_NAME} &> #{CMD_LOG}"
    GlusterFS::Error.check(CMD_LOG, "Starting volume")

  end #block do
end #ruby_block do

# Remove TAG_SPARE from hosts
# (the remote recipe being invoked is intelligent and only removes the tag if
# its brick is in fact part of the volume, thus safe to run on all hosts.)
log "===> Running remote recipes to remove tags"
remote_recipe "delete_tag" do
  recipe "glusterfs::server_handle_tag_updates"
  recipients_tags "#{TAG_SPARE}=true"
end
  
rightscale_marker :end
