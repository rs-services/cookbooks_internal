rightscale_marker :begin

class Chef::Recipe
  include RightScale::ServicesTools
end

if node['redis']['replication']['master_role'] == "slave"

  results = rightscale_server_collection "redis_master" do
    tags ["redis:role=master"]
    secondary_tags ["server:private_ip_0=*"]
    empty_ok false
    action :nothing
  end

  results.run_action(:load)
  if node["server_collection"]["redis_master"]
    log "Server Collection Found"
    node["server_collection"]["redis_master"].to_hash.values.each do |tags|
      master_ip=RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
      master_port=RightScale::Utils::Helper.get_tag_value("redis:port", tags)

      check_connectivity(master_ip,master_port.to_i,60,"Unable to connect to Redis Master")

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
      service "#{node[:redis][:service_name]}" do
        action :restart
      end
    end
  else
    raise "Can not find master tag"
  end
end

rightscale_marker :end