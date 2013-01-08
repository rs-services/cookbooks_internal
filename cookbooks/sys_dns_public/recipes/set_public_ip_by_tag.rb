rightscale_marker :begin

  results = rightscale_server_collection "load_balancers" do
    tags [node[:sys_dns_public][:tags]]
    secondary_tags ["server:public_ip_0=*"]
    empty_ok true
    action :nothing
  end

  results.run_action(:load)
   @host_ip_array=Array.new
   if node["server_collection"]["load_balancers"]
    log "Server Collection Found"
    node["server_collection"]["load_balancers"].to_hash.values.each do |tags|
      @host_ip_array<<RightScale::Utils::Helper.get_tag_value("server:public_ip_0", tags)
    end
  end
  @host_ip_array<<node[:cloud][:public_ips][0] unless @host_ip_array.include?(node[:cloud][:public_ips][0])
  host_ip_string=@host_ip_array.join(',')
  log host_ip_string
  sys_dns "default" do
    id node[:sys_dns][:id]
    address host_ip_string
    region node[:sys_dns][:region]
    action :set_private
  end

rightscale_marker :end
