template "#{node[:solr][:conf_dir]}/replication.xml" do
  source "replication.xml"
  user "tomcat"
  group "tomcat"
  mode "0644"
  #variables ( :solr_persist => "true" )
end
