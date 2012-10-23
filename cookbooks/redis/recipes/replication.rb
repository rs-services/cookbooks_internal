if node['redis']['replication']['master_role'] == "slave"

  results = rightscale_server_collection "redis_master" do
    tags ["redis:role=master"]
    secondary_tags ["server:private_ip_0=*"]
    action :nothing
  end

  results.run_action(:load)

  if node["server_collection"]["redis_master"]
    node["server_collection"]["redis_master"].to_hash.values.each do |tags|
      master_ip=RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
      master_port=RightScale::Utils::Helper.get_tag_value("redis:port", tags)
      template "#{node[:redis][:conf_dir]}/conf.d/replication.conf" do
        source "replication.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        variables( :master_ip => master_ip, 
                   :master_port => master_port
                 )
        action :create
      end
    end
    service "#{node[:redis][:service_name]}" do
      action :restart
    end
  else
    raise "Can not find master tag"
  end
end
