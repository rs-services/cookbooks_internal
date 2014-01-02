rightscale_marker :begin

# XXX The `gluster' binary is unintelligent and does not return useful return
#     codes.  It also sends all errors to stdout.  So we have to grep its
#     output in order to determine success.
#
CMD_LOG = "/tmp/gluster.out.#{$$}"

peer_ip = node[:glusterfs][:server][:peer]

log "===> Attempting to detach #{peer_ip}"
ruby_block "gluster peer detach #{peer_ip}" do
  block do
    result = ""
    IO.popen("gluster peer detach #{peer_ip}") { |gl_io| result = gl_io.gets.chomp }
    if ! File.open("#{CMD_LOG}", 'w') { |file| file.write(result) }
           Chef::Log.info "===> unable to write to #{CMD_LOG}"
    end
    GlusterFS::Error.check(CMD_LOG, "Removing #{peer_ip} from cluster")
  end
end

rightscale_marker :end
