action :install do
  log "installing npm package: #{@new_resource.package_name}"
  if @new_resource.version
    package="#{@new_resource.package_name}@#{@new_resource.version}"
  else
    package=@new_resouce.package_name
  end
  execute "/usr/bin/npm install #{package}"
end

action :upgrade do
  log "installing npm package: #{@new_resource.package_name}"
  execute "/usr/bin/npm upgrade #{@new_resource.package_name}"
end

action :remove do
  log "remove npm package: #{@new_resource.package_name}"
  execute "/usr/bin/npm remove #{@new_resource.package_name}"
end

action :publish do
  log "not implemented yet"
end

action :start do
  log "starting package: #{@new_resource.package_name}"
  execute "/usr/bin/npm start #{@new_resource.package_name}"
end

action :stop do
  log "stopping package: #{@new_resource.package_name}"
  execute "/usr/bin/npm stop #{@new_resource.package_name}"
end

action :restart do
  log "restarting package: #{@new_resource.package_name}"
  execute "/usr/bin/npm restart #{@new_resource.package_name}"
end

