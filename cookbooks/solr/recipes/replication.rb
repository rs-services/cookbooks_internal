rightscale_marker :begin

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

  sys_dns "default" do
    id node[:solr][:replication][:master_dns_id]
    address node[:cloud][:private_ips][0]
    action :set
  end
end

if node[:solr][:replication][:server_type] == "slave"
  template "#{node[:solr][:conf_dir]}/solrconfig_slave.xml" do
    source "solrconfig_slave.xml"
    owner "#{node[:tomcat][:app_user]}"
    group "#{node[:tomcat][:app_user]}"
    mode "0644"
    variables( :slave_poll_interval => node[:solr][:replication][:slave_poll_interval],
               :solr_master_host => node[:solr][:replication][:master]
             )
    notifies :restart, "service[tomcat6]", :delayed
  end

  sys_dns "default" do
    id node[:solr][:replication][:slave_dns_id]
    address node[:cloud][:private_ips][0]
    action :set
  end 
end

service "tomcat6"
rightscale_marker :end
