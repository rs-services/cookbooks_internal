# find all servers marked as 'attached' (joined into trusted pool)
define :find_attached_peer, :tags=>[], :secondary_tags=>[] do

  # Node attribute to populate with joined server's tag
  node[:glusterfs][:server][:peer_uuid_tag] = ""

  sc = rightscale_server_collection "glusterfs_attached" do
    tags params[:tags]
    secondary_tags params[:secondary_tags]
    action :nothing
  end
  sc.run_action(:load)

  # grab the uuid of the first one (doesn't matter which one we use)
  rb = ruby_block "get peer uuid" do
    block do
      node[:server_collection]["glusterfs_attached"].each do |id, tags|
        node[:glusterfs][:server][:peer_uuid_tag] = tags.detect do |u|
          u =~ /^server:uuid=/
        end
        # pretty-print to log
        ip_tag = tags.detect { |i| i =~ /^server:private_ip_0=/ }
        ip = ip_tag.gsub(/^.*=/, '')
        Chef::Log.info "===> Found attached peer #{ip}"
        node[:glusterfs][:server][:peer] = ip
        break # only need one host
      end
    end
  end
  rb.run_action(:create)
end #define :find_attached_peer
