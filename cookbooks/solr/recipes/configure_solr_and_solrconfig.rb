log "Copying and configuring solr.xml to #{node[:solr][:conf_dir]}"
template "#{node[:solr][:install_dir]}/solr.xml" do
  source "solr.xml"
  owner "tomcat"
  group "tomcat"
  mode "0644"
  #variables ( :solr_persist => "true" )
end

log "Copying and configuring solrconfig.xml to #{node[:solr][:conf_dir]}"
template "#{node[:solr][:conf_dir]}/solrconfig.xml" do
  source "solrconfig.xml"
  owner "tomcat"
  group "tomcat"
  mode "0644"
  #variables ( :solr_persist => "true" )
end

