#
# Cookbook Name:: mongo
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
rightscale_marker :begin

gem_package "mongo" do
  gem_binary "/usr/bin/gem"
  action :install
end

gem_package "mongo" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  action :install
end

gem_package "json" do
  gem_binary "/usr/bin/gem"
  version "1.2.4"
  action :install
end

gem_package "json" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "1.2.4"
  action :install
end

rightscale_marker :end
