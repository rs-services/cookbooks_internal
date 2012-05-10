case node[:platform]
when "centos","redhat","scientific"
default[:monit][:package] = "monit"
default[:monit][:conf_dir] = "/etc/monit"
default[:monit][:lib_dir] = ""
when "ubuntu","debian"
default[:monit][:package] = "monit"
default[:monit][:conf_dir] = "/etc/monit"
end

