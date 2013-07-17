
default[:sphinx][:db][:host] = 'localhost'
default[:sphinx][:db][:user] = 'root'
default[:sphinx][:db][:password] = ''
default[:sphinx][:db][:schema] = 'test'
default[:sphinx][:db][:sql_query] = 'SELECT id, group_id, UNIX_TIMESTAMP(date_added) AS date_added, title, content FROM documents'
default[:sphinx][:db][:sql_attr_uint] = 'group_id'
default[:sphinx][:db][:sql_attr_timestamp] = 'date_added'
default[:sphinx][:db][:sql_query_info] = 'SELECT * FROM documents WHERE id=$id'
default[:sphinx][:mem_limit] = '256M'
default[:sphinx][:conf_dir] = '/etc/sphinx'
default[:sphinx][:conf_file] = "#{node[:sphinx][:conf_dir]}/sphinx.conf"
default[:sphinx][:indexer] = "/usr/bin/indexer"
default[:sphinx][:port] = 9312

case node[:platform]
when "redhat","centos","scientific"
  default[:sphinx][:conf_dir] = '/etc/sphinx'
  default[:sphinx][:conf_file] = "#{node[:sphinx][:conf_dir]}/sphinx.conf"
  default[:sphinx][:lib_dir] = '/var/lib/sphinx'
  default[:sphinx][:package] = 'sphinx'
  default[:sphinx][:service] = 'searchd'
  default[:sphix][:mysql_packages] = 'mysql-client,mysql-server'
when "ubuntu", "debian"
  default[:sphinx][:conf_dir] = '/etc/sphinxsearch'
  default[:sphinx][:conf_file] = "#{node[:sphinx][:conf_dir]}/sphinx.conf"
  default[:sphinx][:lib_dir] = '/var/lib/sphinx'
  default[:sphinx][:package] = 'sphinxsearch'
  default[:sphinx][:service] = 'sphinxsearch'
  default[:sphix][:mysql_packages] = 'mysql-client,mysql-server'
end

