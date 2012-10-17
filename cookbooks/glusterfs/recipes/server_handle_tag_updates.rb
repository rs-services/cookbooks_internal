rightscale_marker :begin

# Constants as shortcuts for attributes
# 
TAG_SPARE  = node[:glusterfs][:tag][:spare]
TAG_ATTACH = node[:glusterfs][:tag][:attached]
TAG_VOLUME = node[:glusterfs][:tag][:volume]
TAG_BRICK  = node[:glusterfs][:tag][:brick]

list_tags = "rs_tag --list --format text |tr ' ' '\\n'"
VOL_NAME   = `#{list_tags} |grep '#{TAG_VOLUME}=' |cut -f2 -d=`.chomp
EXPORT_DIR = `#{list_tags} |grep '#{TAG_BRICK}='  |cut -f2 -d=`.chomp
BRICK_NAME = "#{node[:cloud][:private_ips][0]}:#{EXPORT_DIR}"

log "===> Ensuring that my brick is added to the volume..."

# TODO Maybe make this a little prettier by NOT spewing Chef exceptions into
#      syslog when this block fails...maybe just touch a flag on disk and
#      have the right_link_tag resource only run if that file exists
#      (instead of ungracefully halting execution of the recipe).
#
bash "gluster volume info #{VOL_NAME}" do
  code <<-EOF
    if ! gluster volume info #{VOL_NAME} | grep -Gqw '#{BRICK_NAME}'
    then
        echo "!!!> ERROR: Don't see my brick in volume '#{VOL_NAME}'"
        echo "!!!> Output from 'gluster volume info #{VOL_NAME}':"
        gluster volume info #{VOL_NAME}
        exit 1
    fi
    exit 0
  EOF
end

log "===> Ok! Removing tag #{TAG_SPARE}=true"
right_link_tag "#{TAG_SPARE}=true" do
  action :remove
end

log "===> Adding tag #{TAG_ATTACH}=true"
right_link_tag "#{TAG_ATTACH}=true" do
  action :publish
end

right_link_tag "#{node[:glusterfs][:tag][:bricknum]}=#{node[:glusterfs][:tag][:bricknum]}" do
  only_if { node[:glusterfs][:tag][:bricknum] = `gluster volume info glusterFS`.split("\n").select{|x|x=~/#{node[:server][:local_ip]}/}.to_s.split(':')[0].split('Brick')[1] }
  not_if { node[:glusterfs][:tag][:bricknum].empty? }
end

rightscale_marker :end
