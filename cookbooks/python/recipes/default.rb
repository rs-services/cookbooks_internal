#
# Cookbook Name:: python
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
python = Hash.new
case node[:platform]
  when "centos"
    case node[:python][:version]
      when "2.4"
        node[:python][:package]="python"
        node[:python][:binary]="/usr/bin/python"
      when "2.6"
        node[:python][:package]="python26"
        node[:python][:binary]="/usr/bin/python26"
      when "3.0"
        node[:python][:package]="python30"
        node[:python][:binary]="/usr/bin/python3"
    end
  when "ubuntu"
  
end

package node[:python][:package] do
  action :install
end
    
