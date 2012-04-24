rs_utils_marker :begin

include_recipe "sys_dns::default"

template "#{node[:solr][:conf_dir]}/replication.xml" do
  source "replication.xml"
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0644"
  notifies :restart, "service[tomcat6]", :delayed
end

bash "add-replication-to-solr-config" do
  user "root"
  cwd "#{node[:solr][:conf_dir]}"
  code <<-'EOF'
  sed -i -e '/<\/config>/ d' solrconfig.xml
  cat replication.xml >> solrconfig.xml
EOF
  not_if "grep solrconfig_master #{node[:solr][:conf_dir]}/solrconfig.xml"
end

if node[:solr][:replication][:server_type] == "master" 
  template "#{node[:solr][:conf_dir]}/solrconfig_master.xml" do
    source "solrconfig_master.xml"
    owner "#{node[:tomcat][:app_user]}"
    group "#{node[:tomcat][:app_user]}"
    mode "0644"
    variables( :files_to_replicate => node[:solr][:replication][:files_to_replicate] )
    notifies :restart, "service[tomcat6]", :delayed
  end

  node[:sys_dns][:id] = node[:solr][:replication][:master_dns_id]
  include_recipe "sys_dns::do_set_private"
end

if node[:solr][:replication][:server_type] == "slave"
  template "#{node[:solr][:conf_dir]}/solrconfig_slave.xml" do
    source "solrconfig_slave.xml"
    owner "#{node[:tomcat][:app_user]}"
    group "#{node[:tomcat][:app_user]}"
    mode "0644"
    variables( :slave_poll_interval => node[:solr][:replication][:slave_poll_interval] )
    notifies :restart, "service[tomcat6]", :delayed
  end
 
  node[:sys_dns][:id] = node[:solr][:replication][:slave_dns_id]
  include_recipe "sys_dns::do_set_private" 
end

service "tomcat6"
rs_utils_marker :end
