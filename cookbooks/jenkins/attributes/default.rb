case platform
when "redhat","centos"
  default[:jenkins][:config] = "/etc/sysconfig/jenkins"
when "ubuntu"
  default[:jenkins][:config] = "/etc/default/jenkins"
end
