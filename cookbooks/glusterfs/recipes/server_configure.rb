rightscale_marker :begin

ETC_DIR  = "/etc/glusterfs"
VOL_FILE = "#{ETC_DIR}/glusterd.vol"

log "===> Creating #{ETC_DIR}"
directory ETC_DIR

log "===> Templating #{VOL_FILE}"
template VOL_FILE do
  source  "glusterd.vol.erb"
end

log "===> Starting glusterd"
execute "glusterd" do
  not_if "pgrep glusterd"
end

rightscale_marker :end
