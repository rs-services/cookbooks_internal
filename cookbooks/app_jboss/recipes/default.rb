rightscale_marker :begin

log "Setting provider specific settings for JBoss ..."

node[:app][:provider] = "app_jboss"

rightscale_marker :end
