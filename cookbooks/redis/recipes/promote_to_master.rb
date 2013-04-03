# run this when making a slave a master


rightscale_marker :begin

right_link_tag "redis:role=master" do
  action :publish
end

right_link_tag "redis:role=slave" do
  action :remove
end

log "remove replication file on master"
file "#{node[:redis][:conf_dir]}/conf.d/replication.conf" do
  action :delete
end

log "run replication script on slaves"
# Run remote_recipe for each slave 
remote_recipe "run replication" do
  recipe "redis::replication"
  recipients_tags "redis:role=slave"
end
  


#todo
# remote run on all slaves to give it new master IP and Port.
# update replication conf file.

rightscale_marker :end