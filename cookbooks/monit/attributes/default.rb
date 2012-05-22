case node[:platform]
when "centos","redhat","scientific"
default[:monit][:package] = "monit"
default[:monit][:conf_dir] = "/etc"
default[:monit][:lib_dir] = ""
default[:monit][:conf_file] = "#{node[:monit][:conf_dir]}/monit.conf"
default[:monit][:conf_ext_dir] = "/etc/monit.d"
when "ubuntu","debian"
default[:monit][:package] = "monit"
default[:monit][:conf_dir] = "/etc/monit"
default[:monit][:conf_file] = "#{node[:monit][:conf_dir]}/monitrc"
default[:monit][:conf_ext_dir] = "/etc/monit/conf.d"
end

