rs_utils_marker :begin

include_recipe "solr::default"

log "Copying and configuring solr.xml to #{node[:solr][:conf_dir]}"
template "#{node[:solr][:install_dir]}/solr.xml" do
  source "solr.xml"
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0644"
  #variables ( :solr_persist => "true" )
end

log "Copying and configuring solrconfig.xml to #{node[:solr][:conf_dir]}"
template "#{node[:solr][:conf_dir]}/solrconfig.xml" do
  source "solrconfig.xml"
  owner "#{node[:tomcat][:app_user]}"
  group "#{node[:tomcat][:app_user]}"
  mode "0644"
  #variables ( :solr_persist => "true" )
end

rs_utils_marker :end
