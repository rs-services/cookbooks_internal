#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2013, RightScale Inc
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

require 'uri'

package "python26" do 
  action :install
end

remote_file "/tmp/#{URI.parse(node[:nodejs][:source]).path.split('/').last}" do
  source node[:nodejs][:source]
  owner "root"
  group "root"
  mode 0644
  action :create
end

bash "download_and_install" do
  cwd "/tmp"
  code<<-EOF
  tar -xvzf URI.parse(node[:nodejs][:source]).path.split('/').last 
  cd node*
  python26 ./configure
  make
  make install
EOF
end
