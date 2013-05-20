rightscale_marker :begin

log "Starting Jboss..."

# Start jboss service
action :start do
  log "  Running start sequence"
  service "jboss" do
    action :start
    persist false
  end
end

rightscale_marker :end
