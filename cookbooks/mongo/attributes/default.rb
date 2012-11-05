default[:mongo][:install_dir] = '/etc/mongo'
default[:mongo][:conf_dir] = node[:mongo][:install_dir] + '/conf'
default[:mongo][:lib_dir] = node[:mongo][:install_dir] + '/lib'
default[:mongo][:data_dir] = node[:mongo][:install_dir] + '/data'

