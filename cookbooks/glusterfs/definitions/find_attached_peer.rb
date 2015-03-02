# find all servers marked as 'attached' (joined into trusted pool)
define :find_attached_peer, :tags=>[], :secondary_tags=>[] do

  r=ruby_block "find attached peers" do
    block do
      tags = tag_search(node, ["#{params[:tags]}","#{params[:secondary_tags]}"]).first
      node.override[:glusterfs][:server][:peer_uuid_tag] = tags["server:uuid"].first.value
      node.override[:glusterfs][:server][:peer] = tags["server:private_ip_0"].first.value
    end
  end
  r.run_action(:create)
  
  Chef::Log.info "peer #{node[:glusterfs][:server][:peer]}"
  Chef::Log.info "peer_uuid #{node[:glusterfs][:server][:peer_uuid_tag]}"
end #define :find_attached_peer
