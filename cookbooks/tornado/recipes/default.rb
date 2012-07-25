#
# Cookbook Name:: tornado
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
if node[:python][:binary].nil? 
  include_recipe "python::default"
end

remote_file "/tmp/tornado-2.3.tar.gz" do
  source "https://github.com/downloads/facebook/tornado/tornado-2.3.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

bash "extract-and-install" do
  user "root"
  cwd "/tmp"
  code <<-EOF
tar -xvzf tornado-2.3.tar.gz
cd tornado-2.3
#{node[:python][:binary]} setup.py build
#{node[:python][:binary]} setup.py install
EOF

