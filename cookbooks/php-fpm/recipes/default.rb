#
# Cookbook Name:: php53u-fpm
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#uninstall php53u-common if installed, conflicts in the php53u.ini with php53u54-common used by php53u-fpm
rightscale_marker :begin

package "php-common" do
  action :remove
end

package "php53u-fpm" do
  action :install
end

package "php53u-intl" do
  action :install
end

package "php53u-pecl-memcached" do
  action :install
end

bash "set-short-open-tag" do
  code <<-EOF
  sed -i -e 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
EOF
end

service "php-fpm" do
  action :start
end

rightscale_marker :end
