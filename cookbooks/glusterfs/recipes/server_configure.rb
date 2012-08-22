rightscale_marker :begin

ETC_DIR  = "/etc/glusterfs"
VOL_FILE = "#{ETC_DIR}/glusterd.vol"

log "===> Creating #{ETC_DIR}"
directory ETC_DIR

log "===> Templating #{VOL_FILE}"
template VOL_FILE do
  source  "glusterd.vol.erb"
  #XXX Not only does centos not have an init script,
  #    this actually breaks things on ubuntu for some reason. i think it causes
  #    a race condition with the 'service' resource below (hence the reason for
  #    the bash block hack to ensure the service is running).
  #notifies :restart, "service[glusterd]"
end

log "===> Enabling glusterd service"
case node[:platform]
when 'ubuntu'
  service "glusterd" do
    action [ :enable, :start ]
    supports :status => true, :restart => true
    ignore_failure true #XXX See comment above
  end
  #XXX See comment above
  bash "make sure it started" do
    code <<-EOF
      i=0
      while ! pgrep glusterd
      do
        /etc/init.d/glusterd start
        i=`expr $i + 1`
        [ $i -eq 10 ] && break
      done
    EOF
  end
when 'centos'
  # TODO epel package doesn't have an init script
  execute "glusterd" do
      not_if "pgrep glusterd"
  end
end

rightscale_marker :end
