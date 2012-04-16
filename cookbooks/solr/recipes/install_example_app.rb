#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin

log "Including solr recipe as dependency"
include_recipe "solr::default" 

log "Solr Directory: #{node[:solr][:install_dir]}"
log "temporary patch solr_dir= #{node[:solr][:install_dir]}"

solr_dir = "#{node[:solr][:install_dir]}"

template "#{solr_dir}/solr.xml" do
  source "solr.xml"
  owner "tomcat"
end

template "#{solr_dir}/conf/solrconfig.xml" do
  source "solrconfig.xml"
  owner "tomcat"
end

template "#{solr_dir}/conf/schema.xml" do
  source "schema.xml"
  owner "tomcat"
end

service "tomcat6"

template "#{solr_dir}/conf/admin-extra.html" do
  source "admin-extra.html"
  owner "tomcat"
end

template "#{solr_dir}/conf/elevate.xml" do
  source "elevate.xml"
  owner "tomcat"
end

template "#{solr_dir}/conf/mapping-FoldToASCII.txt" do
  source "mapping-FoldToASCII.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/mapping-ISOLatin1Accent.txt" do
  source "mapping-ISOLatin1Accent.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/protwords.txt" do
  source "protwords.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/scripts.conf" do
  source "scripts.conf"
  owner "tomcat"
end

template "#{solr_dir}/conf/spellings.txt" do
  source "spellings.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/stopwords_en.txt" do
  source "stopwords_en.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/stopwords.txt" do
  source "stopwords.txt"
  owner "tomcat"
end

template "#{solr_dir}/conf/synonyms.txt" do
  source "synonyms.txt"
  owner "tomcat"
end

directory "#{solr_dir}/lib/velocity" do
  action :create
  owner "tomcat"
  mode "0755"
end

cookbook_file "#{solr_dir}/lib/velocity/browse.vm" do
  source "velocity/browse.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/clusterResults.vm" do
  source "velocity/clusterResults.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/cluster.vm" do
  source "velocity/cluster.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/doc.vm" do
  source "velocity/doc.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/facet_fields.vm" do
  source "velocity/facet_fields.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/facet_queries.vm" do
  source "velocity/facet_queries.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/facet_ranges.vm" do
  source "velocity/facet_ranges.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/facets.vm" do
  source "velocity/facets.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/footer.vm" do
  source "velocity/footer.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/header.vm" do
  source "velocity/header.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/head.vm" do
  source "velocity/head.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/hit.vm" do
  source "velocity/hit.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/jquery.autocomplete.css" do
  source "velocity/jquery.autocomplete.css"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/jquery.autocomplete.js" do
  source "velocity/jquery.autocomplete.js"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/layout.vm" do
  source "velocity/layout.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/main.css" do
  source "velocity/main.css"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/querySpatial.vm" do
  source "velocity/querySpatial.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/query.vm" do
  source "velocity/query.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/suggest.vm" do
  source "velocity/suggest.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/tabs.vm" do
  source "velocity/tabs.vm"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/lib/velocity/VM_global_library.vm" do
  source "velocity/VM_global_library.vm"
  owner "tomcat"
end

directory "#{solr_dir}/conf/xslt" do
  action :create
  owner "tomcat"
  mode "0755"
end

cookbook_file "#{solr_dir}/conf/xslt/example_atom.xsl" do
  source "xslt/example_atom.xsl"
  owner "tomcat"
end
 
cookbook_file "#{solr_dir}/conf/xslt/example_rss.xsl" do
  source "xslt/example_rss.xsl"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/conf/xslt/example.xsl" do
  source "xslt/example.xsl"
  owner "tomcat"
end

cookbook_file "#{solr_dir}/conf/xslt/luke.xsl" do
  source "xslt/luke.xsl"
  owner "tomcat"
end
rs_utils_marker :end
