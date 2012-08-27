#
# Cookbook Name:: aria2
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
case node[:platform]
when "centos"
  package "openssl-devel" do
    action :install
  end
  remote_file "/tmp/aria2-1.14.1-1.x86_64.rpm" do
    source "http://application-binaries.s3.amazonaws.com/aria2-1.14.1-1.x86_64.rpm"
    mode "0644"
  end
  package "aria2" do
    source "/tmp/aria2-1.14.1-1.x86_64.rpm"
    provider provider Chef::Provider::Package::Rpm
  end
when "ubuntu"
  package "aria2" do
    action :install
  end
end
