results = rightscale_server_collection "redis_master" do
  tags ["redis:role=master"]
  secondary_tags ["server:private_ip_0=*"]
  action :nothing
end

results.run_action(:load)

if node["server_collection"]["redis_master"]
  node["server_collection"]["redis_master"].to_hash.values.each do |tags|
    log RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
  end
else
  log " ERROR: Install couchbase first before running this recipe."
end
