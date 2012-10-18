#
# Cookbook Name:: ftp
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
class Chef::Recipe
  include TestLib
end

ruby_block "do_min_port_check" do
  block do
    min_port=node['vsftpd']['pasv_min_port']
    raise "min_port is not an integer" unless TestLib::integer?(min_port)
    raise "min_port has to be larger then 1024" unless min_port.to_i >= 1024
  end
  action :create
end
