action :set do
  log "setting npm config:#{@new_resource.key} to #{@new_resource.value}"
  execute "/usr/bin/npm config set #{@new_resource.key} #{@new_resource.value}"
end

action :get do
  log "get npm config:#{@new_resource.key}"
  execute "/usr/bin/npm config get #{@new_resource.key}"
end

action :delete do
  log "setting npm config:#{@new_resource.key} to #{@new_resource.value}"
  execute "/usr/bin/npm config delete #{@new_resource.key}"
end

action :list do
  log "listing npm config"
  execute "/usr/bin/npm config list"
end

