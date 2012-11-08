default[:mongo][:install_dir] = '/usr/local/mongodb'
default[:mongo][:conf_dir] = '/etc'
default[:mongo][:lib_dir] = node[:mongo][:install_dir] + '/lib'
default[:mongo][:data_dir] = '/var/lib/mongodb'
default[:mongo][:log_dir] = '/var/log/mongodb'
default[:mongo][:user] = 'mongodb'
default[:mongo][:pid_dir] = '/var/run/mongo'
default[:mongo][:source] = "http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.2.1.tgz"
default[:mongo][:port]=27017
default[:mongo][:web_admin_port]=28017


case node[:platform]
  when "centos","redhat"
    default[:mongo][:package] = "mongo"
    default[:mongo][:service] = "mongod"
    default[:mongo][:conf_file] = node[:mongo][:conf_dir]+'/'+node[:mongo][:service]+'.conf'
    default[:mongo][:user] = 'mongod'
  when "ubuntu","debian"
    default[:mongo][:package] = "mongo"
    default[:mongo][:service] = "mongodb"
    default[:mongo][:conf_file] = node[:mongo][:conf_dir]+'/'+node[:mongo][:service]+'.conf'
  else
    raise "os unsupported"
end
