rightscale_marker :begin

%w{gcc gcc-c++ libdb-devel db4-devel krb5-devel icu libicu-devel net-snmp-devel lm_sensors-devel bzip2-devel zlib-devel openssl-devel tcp_wrappers libselinux-devel cyrus-sasl cyrus-sasl-devel cyrus-sasl-gssapi cyrus-sasl-md5 pam-devel pcre-devel openldap-devel svrcore-devel nss-devel nspr-devel java ant httpd-devel apr-devel}.each do |pkg|
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

rightscale_marker :end
