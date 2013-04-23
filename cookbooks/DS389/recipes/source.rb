rightscale_marker :begin

%w{gcc gcc-c++ db4-devel krb5-devel icu libicu-devel net-snmp-devel lm_sensors-devel bzip2-devel zlib-devel openssl-devel tcp_wrappers libselinux-devel cyrus-sasl cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-md5 pam-devel pcre-devel openldap-devel svrcore-devel nss-devel nspr-devel java ant httpd-devel apr-devel perl-Mozilla-LDAP perl-NetAddr-IP policycoreutils-python mod_nss}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/tmp/389.tar.bz2" do
  source "http://port389.org/sources/389-ds-base-1.3.0.4.tar.bz2"
  mode "0664"
  owner "root"
  group "root"
  action :create
end

bash "unzip and install" do
  code <<-EOF
  cd /tmp/
  tar -xjf 389.tar.bz2
  cd 389*
  ./configure --prefix=/usr --sysconfdir=/etc --with-openldap --enable-autobind --with-selinux --quiet
  make all --quiet
  make install --quiet
EOF
end

remote_file "/tmp/389-admin-util.tar.bz2" do
  source "http://port389.org/sources/389-adminutil-1.1.14.tar.bz2"
  mode "0664"
  owner "root"
  group "root"
  action :create
end

bash "unzip and install" do
  code <<-EOF
  cd /tmp/
  tar -xjf 389-admin-util.tar.bz2
  cd 389-adminutil*
  ./configure --prefix=/usr --sysconfdir=/etc --with-openldap --quiet
  make all --quiet
  make install --quiet
EOF
end

remote_file "/tmp/389-admin.tar.bz2" do
  source "http://port389.org/sources/389-admin-1.1.31.tar.bz2"
  mode "0664"
  owner "root"
  group "root"
  action :create
end

bash "unzip and install" do
  code <<-EOF
  cd /tmp/
  tar -xjf 389-admin.tar.bz2
  cd 389-admin-*
  ./configure --prefix=/usr --sysconfdir=/etc --with-openldap --quiet
  make all --quiet
  make install --quiet
EOF
end

rightscale_marker :end
