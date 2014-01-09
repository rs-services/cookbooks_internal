rightscale_marker :begin

brick_old=node[:glusterfs][:server][:storage_path]
brick_path=node[:glusterfs][:server][:storage_path]
brick_path[0]=''
logrotate_app 'gluster-brick' do
  cookbook  'logrotate'
  paths      "/var/log/glusterfs/bricks/#{brick_path.gsub('/','-')}.log"
  frequency 'daily'
  rotate    7
  create    '644 root root'
end

node[:glusterfs][:server][:storage_path]=brick_old

rightscale_marker :end
