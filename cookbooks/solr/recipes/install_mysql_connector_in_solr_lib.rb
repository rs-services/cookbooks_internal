rs_utils_marker :begin

include_recipe 'solr::default'

log "linking mysql-connector into solr lib"
link "#{node[:solr][:lib_dir]}/mysql-connector-java.jar" do
  to "/usr/share/java/mysql-connector-java.jar"
  action :create
  link_type :symbolic
  only_if "test -e /usr/share/java/mysql-connector-java.jar"
  not_if "test -e #{node[:solr][:lib_dir]}/mysql-connector-java.jar"
  notifies :restart, "service[tomcat6]", :delayed
end

service "tomcat6"

rs_utils_marker :end
