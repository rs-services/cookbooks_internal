# find all servers marked as 'spare'
define :find_all_spares, :tags=>[], :secondary_tags=>[] do

  # Node attribute to populate with list of IPs
  node[:glusterfs][:server][:spares] = []

  # Search the tag space
  sc = rightscale_server_collection "glusterfs_spares" do
    tags params[:tags]
    secondary_tags params[:secondary_tags]
    action :nothing
  end
  sc.run_action(:load)

  # Grab the internal IPs of all results
  hosts_found = []
  node[:server_collection]["glusterfs_spares"].each do |id, tags|
    ip_tag = tags.detect { |i| i =~ /^server:private_ip_0=/ }
    ip = ip_tag.gsub(/^.*=/, '')
    Chef::Log.info "===> Found server #{ip}"
    hosts_found << ip
  end

  # (sanity check)
  if hosts_found.empty?
    raise "!!!> Didn't find any servers tagged with #{params[:tags]} " +
      "and #{params[:secondary_tags]}"
  end

  # Populate node attr
  node[:glusterfs][:server][:spares] = hosts_found

end #define :find_spares
