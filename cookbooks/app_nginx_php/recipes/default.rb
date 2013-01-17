#
# Cookbook Name:: app_nginx_php
# Recipe:: default
#
# Copyright 2012, RightScale Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Cookbook Name:: app_php
#
# Copyright RightScale, Inc. All rights reserved. All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

log " Setting provider specific settings for php application server."
node[:app][:provider] = "app_nginx_php"

# Preparing list of database adapter packages depending on platform and database adapter
case node[:platform]
when "ubuntu", "debian"
  if node[:app_php][:db_adapter] == "mysql"
    node[:app][:packages] = [
      "php5",
      "php5-mysql",
      "php-pear",
    ]
  elsif node[:app_php][:db_adapter] == "postgresql"
    node[:app][:packages] = [
      "php5",
      "php5-pgsql",
      "php-pear",
    ]
  else
    raise "Unrecognized database adapter #{node[:app][:db_adapter]}, exiting "
  end
when "centos","fedora","suse","redhat"
  if node[:app_php][:db_adapter] == "mysql"
    node[:app][:packages] = [
      "php53u",
      "php53u-mysql",
      "php53u-pear",
      "php53u-zts"
    ]
  elsif node[:app_php][:db_adapter] == "postgresql"
    node[:app][:packages] = [
      "php53u",
      "php53u-pgsql",
      "php53u-pear",
      "php53u-zts"
    ]
  else
    raise "Unrecognized database adapter #{node[:app_php][:db_adapter]}, exiting "
  end
else
  raise "Unrecognized distro #{node[:platform]}, exiting "
end


# Setting app LWRP attribute
node[:app][:root] = "#{node[:repo][:default][:destination]}/#{node[:web_apache][:application_name]}"
# PHP shares the same doc root with the application destination
node[:app][:destination] = "#{node[:app][:root]}"

directory "#{node[:app][:destination]}" do
  recursive true
end

rightscale_marker :end
