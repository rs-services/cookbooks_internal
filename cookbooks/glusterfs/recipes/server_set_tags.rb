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

log "===> Tagging myself with #{TAG_SPARE}=true"
right_link_tag "#{TAG_SPARE}=true" do
  action :publish
end

right_link_tag "#{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:tag][:bricknum]}" do
  only_if { node[:glusterfs][:tag][:bricknum] = `gluster volume info glusterFS`.split("\n").select{|x|x=~/#{node[:server][:local_ip]}/}.to_s.split(':')[0].split('Brick')[1] }
  not_if { node[:glusterfs][:tag][:bricknum].empty? }
end


rightscale_marker :end
