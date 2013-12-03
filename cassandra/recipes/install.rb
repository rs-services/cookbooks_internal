#
# Cookbook Name:: cassandra
# Recipe:: install
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

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
    sudo alternatives --install /usr/bin/java java /usr/java/jre1.7.0_version/bin/java 20000
  EOM
end

rightscale_marker :end
