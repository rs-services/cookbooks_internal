# Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# think this should be an op script.

rightscale_marker :begin

if cluster_tag and !cluster_tag.empty?
  log("auto-joining nodes search...")

  # Query for fellow tagged couchbase cluster nodes
  # @return [Hash] couchbase_servers hash of couchbase cluster tagged servers in deployment
  def query_couchbase_servers

    couchbase_servers = Hash.new
 
    r=rightscale_server_collection 'couchbase_cluster_nodes' do
      tags ["couchbase:cluster_ip=#{cluster_ip}"]
      secondary_tags ["server:uuid=*", "couchbase:listen_ip=*"]
      action :nothing
    end
    r.run_action(:load)
 
    node[:server_collection]['couchbase_cluster_nodes'].to_hash.values.each do |tags|
      uuid = RightScale::Utils::Helper.get_tag_value('server:uuid', tags)
      ip = RightScale::Utils::Helper.get_tag_value('couchbase:listen_ip', tags)
      couchbase_servers[uuid] = {}
      couchbase_servers[uuid][:ip] = ip
    end
 
    couchbase_servers
 
  end
  
  # Anyways, here's the join cluster command using the couchbase:cluster_ip tag set in theh init_cluster recipe, if you ran it
    log"Joining a cluster node "
  
  # replace ip node with ip taken from tags.. 
  log("/opt/couchbase/bin/couchbase-cli server-add" +
      " --server-add=self" +
      " --server-add-username=#{node[:db_couchbase][:cluster][:username]}" +
      " --server-add-password=#{node[:db_couchbase][:cluster][:password]}" +
      " -p #{node[:db_couchbase][:cluster][:password]}" +
      " -u #{node[:db_couchbase][:cluster][:username]}" +
      " #{couchbase_servers[0]}" 
     )
  execute "Joining cluster  #{node[:db_couchbase][:cluster][:tag]}" do
    command("sleep 20 &&" +
      "/opt/couchbase/bin/couchbase-cli server-add" +
      " --server-add=self" +
      " --server-add-username=#{node[:db_couchbase][:cluster][:username]}" +
      " --server-add-password=#{node[:db_couchbase][:cluster][:password]}" +
      " -p #{node[:db_couchbase][:cluster][:password]}" +
      " -u #{node[:db_couchbase][:cluster][:username]}" +
      " #{couchbase_servers[0]}" 
           )
    action :run
  end
  
  else
  log "No cluster_tag set or couchbase:cluster_ip set"

end

rightscale_marker :end


