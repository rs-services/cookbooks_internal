rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"
peer_ip = node[:glusterfs][:server][:peer]

log "===> Going to probe #{peer_ip}"
ruby_block "gluster peer probe #{peer_ip}" do
  block do
    # TODO netcat the port
    system "gluster peer probe #{peer_ip} &> #{CMD_LOG}"
    GlusterFS::Error.check(CMD_LOG, "Adding #{peer_ip} to cluster")
  end
end

rightscale_marker :end
