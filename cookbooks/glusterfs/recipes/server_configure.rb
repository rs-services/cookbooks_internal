marker "recipe_start_rightscale" do
  template "rightscale_audit_entry.erb"
end

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
case node[:platform_family]
when 'debian'
  service node["glusterfs"]["servicename"] do
    action [ :enable, :start ]
    supports :status => true, :restart => true
    ignore_failure true #XXX See comment above
  end
  #XXX See comment above
 b= bash "make sure it started" do
    code <<-EOF
      i=0
      while ! pgrep glusterd
      do
        /etc/init.d/glusterfs-server start
        i=`expr $i + 1`
        [ $i -eq 10 ] && break
      done
    EOF
    action :nothing
  end
  b.run_action(:run)
when 'rhel'
  service node["glusterfs"]["servicename"] do
    action [ :enable, :start ]
    supports :status => true, :restart => true
    ignore_failure true
  end
end

directory node[:glusterfs][:log_dir] do
  owner "root"
  group "root"
  mode 0755
  recursive true
  action :create
end

directory node[:glusterfs][:server][:storage_path] do
  owner "root"
  group "root"
  mode 0755
  recursive true
  not_if "test -e #{node[:glusterfs][:server][:storage_path]}"
  action :create
end
