
default[:app_nettyio][:version]="3.5.8"
default[:app_nettyio][:install_dir]="/opt/netty.io"

case node[:platform]
when "ubuntu"
  default[:java][:home] = "/usr/lib/jvm/java-1.6.0-openjdk-amd64"
when "centos", "redhat"
  default[:java][:home] = "/usr/lib/jvm/java-1.6.0"
end
