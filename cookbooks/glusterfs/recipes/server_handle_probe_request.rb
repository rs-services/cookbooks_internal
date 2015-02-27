marker "recipe_start"

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.server_handle_probe_request.out.#{$$}"
peer_ip = node[:glusterfs][:server][:peer]

log "===> Going to probe #{peer_ip}"
ruby_block "gluster peer probe #{peer_ip}" do
  block do
    result = ""
    IO.popen("gluster peer probe #{peer_ip}") { |gl_io| result = gl_io.gets.chomp }
    if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
    end
    GlusterFS::Error.check(CMD_LOG, "Adding #{peer_ip} to cluster")
  end
end
