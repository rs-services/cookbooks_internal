#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

# Recommended production settings: http://www.datastax.com/documentation/cassandra/1.2/webhelp/index.html#cassandra/install/installRecommendSettings.html

rightscale_marker :begin

right_link_tag "cassandra:seed_host=#{node[:cassandra][:is_seed_host]}"

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:version_rpm]}" do
  source "#{node[:cassandra][:version]}"
  checksum "6e41d897c052a7d4efbbb6d2be1fb61a79492d058333ab496ef9d678910eb6e6"
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:datastax_rpm]}" do
  source "#{node[:cassandra][:datastax]}"
  checksum "38a29503f913daea343b22964608898f3f33c08bb02b6046ab1b9d1d12089db0"
  action :create
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:jre_rpm]}" do
  source "#{node[:cassandra][:jre]}"
  checksum "b3d28c3415cffd965a63cd789d945cf9da827d960525537cc0b10c6c6a98221a"
  action :create
end

package "jna" do
  action :install
end

package "cassandra12" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:version_rpm]}"
  provider Chef::Provider::Package::Rpm
end

package "dsc12" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:datastax_rpm]}"
  provider Chef::Provider::Package::Rpm
end

package "jre" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/#{node[:cassandra][:jre_rpm]}"
  provider Chef::Provider::Package::Rpm
end

remote_file "/usr/java/jre1.7.0_45/lib/security/US_export_policy.jar" do
  source "#{node[:cassandra][:us_export_policy]}"
  checksum "b800fef6edc0f74560608cecf3775f7a91eb08d6c3417aed81a87c6371726115"
  owner "root"
  group "root"
  mode "0644"
  backup false
  action :create
end

remote_file "/usr/java/jre1.7.0_45/lib/security/local_policy.jar" do
  source "#{node[:cassandra][:local_policy]}"
  checksum "4a5c8f64107c349c662ea688563e5cd07d675255289ab25246a3a46fc4f85767"
  owner "root"
  group "root"
  mode "0644"
  backup false
  action :create
end

bash "update_alternatives_to_oracle_java" do
  flags "-ex"
  code <<-EOM
    alternatives --install /usr/bin/java java /usr/java/jre1.7.0_45/bin/java 20000
  EOM
end

cookbook_file "/etc/sysctl.conf" do
  source "sysctl.conf"
  mode "0644"
  owner "root"
  group "root"
  action :create
end

cookbook_file "/etc/security/limits.d/cassandra.conf" do
  source "cassandra.conf"
  owner "root"
  group "root"
  mode "0644"
  backup false
  action :create
end

cookbook_file "/etc/cassandra/conf/cassandra-env.sh" do
  source "cassandra-env.sh"
  owner "cassandra"
  group "cassandra"
  mode "0755"
  action :create
end

bash "disable_swap" do
  flags "-ex"
  code <<-EOM
    swapoff --all
  EOM
end

rightscale_marker :end
