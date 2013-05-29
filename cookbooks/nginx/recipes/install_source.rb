rightscale_marker :begin

%w{GeoIP-devel gd-devel libxslt-devel openssl-devel pcre-devel perl-devel zlib-devel GeoIP gd libxslt openssl pcre shadow-utils chkconfig initscripts perl-ExtUtils-Embed}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/tmp/nginx.tar.gz" do
  source "http://nginx.org/download/nginx-1.1.2.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

group "nginx" do
  gid 499
  action :create
end

user "nginx" do
  comment "Nginx web server"
  uid 498
  gid "nginx"
  home "/var/lib/nginx"
  shell "/sbin/nologin"
  system true
  action :create
end 


%w{ /usr/share/nginx /var/log/nginx /etc/nginx /var/lib/nginx/tmp}.each do |dir|
  directory dir do
    owner "nginx"
    group "nginx" 
    mode "0777"
    recursive true
    action :create
  end
end

bash "extract and compile" do
  code <<-EOF
    cd /tmp
    tar -xzf nginx.tar.gz
    cd nginx*
    ./configure --prefix=/usr/share/nginx \
    --sbin-path=/ncom/ncom_bin/sbin/nginx \
    --conf-path=/ncom/ncom_bin/conf/nginx.conf \
    --error-log-path=/ncom/ncom_bin/logs/error.log \
    --http-log-path=/ncom/ncom_bin/logs/access.log \
    --http-client-body-temp-path=/ncom/ncom_bin/client_body_temp \
    --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
    --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
    --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
    --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/subsys/nginx \
    --user=nginx \
    --group=nginx \
    --with-ipv6 \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_xslt_module \
    --with-http_image_filter_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_degradation_module \
    --with-http_stub_status_module \
    --with-http_perl_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-debug
    make
    make install
  EOF
end

%w{ /ncom/ncom_bin/uwsgi_temp /ncom/ncom_bin/nas /ncom/ncom_bin/html /ncom/ncom_bin/client_body_temp /ncom/ncom_bin/sbin /ncom/ncom_bin/cert /ncom/ncom_bin/conf /ncom/ncom_bin/conf/ssl_priv /ncom/ncom_bin/conf/ssl /ncom/ncom_bin/logs /ncom/ncom_bin/logs/dig /ncom/ncom_bin/logs/temp /ncom/ncom_bin/proxy_temp}.each do |dir|
  directory dir do
    owner "nginx"
    group "nginx" 
    mode "0777"
    recursive true
    action :create
  end
end

cookbook_file "/etc/init.d/nginx" do
  source "nginx_init.erb"
  owner "root"
  group "root"
  mode "0777"
  action :create
end

service "nginx" do
  action :enable
end

rightscale_marker :end
