Cookbook Name:: couchbase
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# think this should be an op script.

rightscale_marker :begin

log "Setting cluster_ip tag to #{node[:couchbase][:ip]}"
right_link_tag "couchbase:cluster_ip=#{node[:couchbase][:ip]}"

# Using the tag for the cluster ip as the join ip
log("/opt/couchbase/bin/couchbase-cli cluster-init" +
    "        -c #{node[:couchbase][:ip]:8091" +
    "        --cluster-init-username=#{node[:db_couchbase][:cluster][:username]}")
execute "initializing cluster with username: #{node[:db_couchbase][:cluster][:username]}" do
  command("sleep 20" +
          " && /opt/couchbase/bin/couchbase-cli cluster-init" +
          "        -c #{node[:couchbase][:ip]}:8091" +
          "        --cluster-init-username=#{node[:db_couchbase][:cluster][:username]}" +
          "        --cluster-init-password=#{node[:db_couchbase][:cluster][:password]}")
  action :run
end

log "Setting cluster_ip tag to #{node[:couchbase][:ip]}"
right_link_tag "couchbase:cluster_ip=#{node[:couchbase][:ip]}"

rightscale_marker :end

