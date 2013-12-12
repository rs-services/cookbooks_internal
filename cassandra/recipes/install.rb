#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

# Recommended production settings: http://www.datastax.com/documentation/cassandra/2.0/webhelp/index.html#cassandra/install/installRecommendSettings.html

rightscale_marker :begin

right_link_tag "cassandra:seed_host=#{node[:cassandra][:is_seed_host]}"
right_link_tag "cassandra:cloud=#{node[:cloud][:provider]}" 

if node[:cloud][:provider] == "ec2"
  right_link_tag "cassandra:region=#{node[:ec2][:placement][:availability_zone]}"
elsif node[:cloud][:provider] == "google"
  right_link_tag "cassandra:region=#{node[:google][:zone].split('/').last}"
end

remote_file "#{Chef::Config[:file_cache_path]}/cassandra20-2.0.3-1.noarch.rpm" do
  source "http://stefhen-rightscale.s3.amazonaws.com/cassandra/cassandra20-2.0.3-1.noarch.rpm"
  checksum "8d403cfeb0b7a4136da97402a49364e30caaeca0a5daf981fdd839900e3cd4c8"
end

remote_file "#{Chef::Config[:file_cache_path]}/dsc20-2.0.3-1.noarch.rpm" do
  source "http://stefhen-rightscale.s3.amazonaws.com/cassandra/dsc20-2.0.3-1.noarch.rpm"
  checksum "6122f34b3d9bcc425b4663c397c2ce3331c2ef6b25e31ab5f8e91b84a682b0de"
end

remote_file "#{Chef::Config[:file_cache_path]}/jre-7u45-linux-x64.rpm" do
  source "http://stefhen-rightscale.s3.amazonaws.com/cassandra/jre-7u45-linux-x64.rpm"
  checksum "b3d28c3415cffd965a63cd789d945cf9da827d960525537cc0b10c6c6a98221a"
end

package "jna" do
  action :install
end

package "cassandra20" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/cassandra20-2.0.3-1.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

package "dsc20" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/dsc20-2.0.3-1.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

package "jre" do
  action :install
  source "#{Chef::Config[:file_cache_path]}/jre-7u45-linux-x64.rpm"
  provider Chef::Provider::Package::Rpm
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
end

bash "disable_swap" do
  flags "-ex"
  code <<-EOM
    swapoff --all
  EOM
end

rightscale_marker :end
