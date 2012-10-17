rightscale_marker :begin

TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]
TAG_SPARE  = node[:glusterfs][:tag][:spare]

INPUT_VOLUME = node[:glusterfs][:volume_name]
INPUT_BRICK  = node[:glusterfs][:server][:storage_path]

log "===> Tagging myself with #{TAG_VOLUME}=#{INPUT_VOLUME}"
right_link_tag "#{TAG_VOLUME}=#{INPUT_VOLUME}" do
  action :publish
end

log "===> Tagging myself with #{TAG_BRICK}=#{INPUT_BRICK}"
right_link_tag "#{TAG_BRICK}=#{INPUT_BRICK}" do
  action :publish
end

log "===> Tagging myself with #{TAG_SPARE}=true"
right_link_tag "#{TAG_SPARE}=true" do
  action :publish
end

if ! #{TAG_SPARE} == true
  foo = `gluster volume info #{INPUT_VOLUME}`.split("\n").select{|x|x=~/#{node[:cloud][:private_ips][0]}/}

  if foo.to_s == ''
     foo = "Brick0:"
  end

  node[:glusterfs][:server][:brick] = foo.to_s.split(':')[0].tr('Brick', '')

  log "===> Tagging myself with #{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:server][:brick]}"
  right_link_tag "#{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:server][:brick]}" do
    action :publish
  end
end

rightscale_marker :end
