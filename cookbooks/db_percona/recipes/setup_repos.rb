#
# Cookbook Name:: db_percona
#
# Copyright RightScale, Inc. All rights reserved.
# All access and use subject to the RightScale Terms of Service available at
# http://www.rightscale.com/terms.php and, if applicable, other agreements
# such as a RightScale Master Subscription Agreement.

rightscale_marker

platform = node[:platform]
  
bash "update yum repo for percona" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
  EOH
  only_if { platform =~ /redhat|centos/ }
end
  
bash "update apt-get repo for percona" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
    cat<<'EOF' >/etc/apt/sources.list.d/percona.list
deb http://repo.percona.com/apt #{node['lsb']['codename']} main
deb-src http://repo.percona.com/apt #{node[:lsb][:codename]} main
EOF
    apt-get update
  EOH
  only_if { platform =~ /ubuntu/ }
end
