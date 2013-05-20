rightscale_marker :begin

log "Re-starting Jboss..."

# Restart jboss service
action :restart do
  log "  Running restart sequence"
  service "jboss" do
    action :restart
    persist false
  end
end

rightscale_marker :end
