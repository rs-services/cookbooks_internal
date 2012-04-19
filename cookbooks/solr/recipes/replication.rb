rs_utils_marker :begin

if node[:solr][:replication][:server_type] == "master" 
  template "#{node[:solr][:conf_dir]}/solrconfig_master.xml" do
    source "solrconfig_master.xml"
    owner "#{node[:tomcat][:app_user]}"
    group "#{node[:tomcat][:app_user]}"
    mode "0644"
    #variables ( :solr_persist => "true" )
  end
end

if node[:solr][:replication][:server_type] == "slave"
  template "#{node[:solr][:conf_dir]}/solrconfig_slave.xml" do
    source "solrconfig_slave.xml"
    owner "#{node[:tomcat][:app_user]}"
    group "#{node[:tomcat][:app_user]}"
    mode "0644"
  end
end

rs_utils_marker :end
