 
# Cookbook Name:: nuodb
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

# Set the nuodb instance type tag

right_link_tag "nuodb:nuodb_type=#{node[:nuodb][:nuodb_type]}"

rightscale_server_collection "nuodb_peers" do
  tags ["nuodb:nuodb_peer=*"]
  empty_ok true
  action :load
end

ruby_block "create_peer" do
  block do
    node[:server_collection]['nuodb_peers'].to_hash.values.each do |tags|
      ip = RightScale::Utils::Helper.get_tag_value('nuodb:nuodb_peer', tags)
      node[:nuodb_peers].push(ip)
    end
  end
end

# Case install and if nuodb is not installed yet, install it

unless ::File.exists?('/opt/nuodb/etc/default.properties')
  log "Including install recipe"
  include_recipe 'nuodb::install_nuodb'
end

# Case nuodb_type and run appropriate action

# Tag myself as a peer, set broker flag true and start broker as peer 
if (node[:nuodb][:nuodb_type]=='broker+peer') then 
  log "Including set peer recipe and start broker recipe "
  include_recipe 'nuodb::set_peer'
  include_recipe 'nuodb::start_nuodb_broker' 
end

# broker only
if (node[:nuodb][:nuodb_type]=='nuodbbroker') then
  log "Including start broker recipe"
  include_recipe 'nuodb::start_nuodb_broker' 
end

# transaction engine
if (node[:nuodb][:nuodb_type]=='trans') then
  log "Including start transaction recipe"
  include_recipe 'nuodb::start_trans' 
end

# storage engine
if (node[:nuodb][:nuodb_type]=='stor') then
  log "Including start storage engine recipe"
  include_recipe 'nuodb::start_stor' 
end

rightscale_marker :end
