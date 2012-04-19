if node[:solr][:replication][:server_type] == "master" do 
  template "#{node[:solr][:conf_dir]}/solrconfig_master.xml" do
    source "solrconfig_master.xml"
    owner "tomcat"
    group "tomcat"
    mode "0644"
    #variables ( :solr_persist => "true" )
  end
end

if node[:solr][:replication][:server_type] == "slave" do
  template "#{node[:solr][:conf_dir]}/solrconfig_slave.xml" do
    source "solrconfig_slave.xml"
    owner "tomcat"
    group "tomcat"
    mode "0644"
  end
end
