marker "recipe_start"

TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
TAG_SPARE  = node[:glusterfs][:tag][:spare]

INPUT_VOLUME = node[:glusterfs][:volume_name]
INPUT_BRICK  = node[:glusterfs][:server][:storage_path]

include_recipe 'machine_tag'

log "===> Tagging myself with #{TAG_VOLUME}=#{INPUT_VOLUME}"
 machine_tag  "#{TAG_VOLUME}=#{INPUT_VOLUME}" do
  action :create
end

log "===> Tagging myself with #{TAG_BRICK}=#{INPUT_BRICK}"
machine_tag "#{TAG_BRICK}=#{INPUT_BRICK}" do
  action :create
end

log "===> Tagging myself with #{TAG_SPARE}=true"
machine_tag "#{TAG_SPARE}=true" do
  action :create
end

if ! #{TAG_SPARE} == true
  vol_info = Mixlib::ShellOut.new("gluster volume info #{INPUT_VOLUME}")
  foo = vol_info.split("\n").select{|x|x=~/#{node[:cloud][:private_ips][0]}/}
  #foo = `gluster volume info #{INPUT_VOLUME}`.split("\n").select{|x|x=~/#{node[:cloud][:private_ips][0]}/}

  if foo.to_s == ''
     foo = "Brick0:"
  end

  node[:glusterfs][:server][:brick] = foo.to_s.split(':')[0].tr('Brick', '')

  log "===> Tagging myself with #{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:server][:brick]}"
  machine_tag "#{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:server][:brick]}" do
    action :create
  end
end
