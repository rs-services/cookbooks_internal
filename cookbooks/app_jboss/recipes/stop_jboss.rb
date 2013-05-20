rightscale_marker :begin

log "Stopping Jboss..."

# Stop jboss service
action :stop do
  log "  Running stop sequence"
  service "jboss" do
    action :stop
    persist false
  end
end

rightscale_marker :end
