# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

define :gluster_peer_probe, :peers => [] do
  #
  # Probe each IP
  Chef::Log.info "probing peers #{params[:peers].inspect}"
  ruby_block "Probe IPs" do
    block do
      require 'mixlib/shellout'
      #Chef::Log.info params[:peers].inspect
      params[:peers].each do |ip|
        # always skip ourself
        if ip == node[:cloud][:private_ips][0]
          Chef::Log.info "===> Skipping myself (#{ip})"
          next
        end

        # check if IP is already connected!
        # (If he is already connected, it's probably from a previous failure
        # of this recipe since he's still marked as spare)
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
         # TODO netcat the por
         result = ""
          Chef::Log.info "===>  - not peered, sending probe command"
          Mixlib::ShellOut.new("gluster peer probe #{ip}").run_command
         # GlusterFS::Error.check(CMD_LOG, "Adding #{ip} to cluster")
        end

      end #params[:peers].each |ip|
    end #block
  end #ruby_block

end #define :glusterfs_peer_probe
