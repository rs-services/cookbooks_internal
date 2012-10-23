results = rightscale_server_collection "redis_master" do
  tags ["redis:role=master"]
  secondary_tags ["server:private_ip_0=*"]
  action :nothing
end

results.run_action(:load) unless node['redis']['replication']['master_role'] =="master"

if node["server_collection"]["redis_master"]
  node["server_collection"]["redis_master"].to_hash.values.each do |tags|
    master_ip=RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
    template "#{node[:redis][:conf_dir]}/conf.d/replication-#{master_ip}.conf" do
      source "replication.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables( :master_ip => master_ip, 
                 :master_port => 6379
               )
      action :create
    end
  end
  service "#{node[:redis][:service_name]}" do
    action :restart
  end
else
  log " ERROR: Install couchbase first before running this recipe."
end
