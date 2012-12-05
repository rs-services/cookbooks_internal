#
# Cookbook Name:: jenkins
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

case node[:platform]
when "centos", "redhat"
	yum_key "RPM-GPG-KEY-jenkins" do
		url "http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
	end

	yum_repository "jenkins" do
		description "Jenkins CI Yum repository"
		url "http://pkg.jenkins-ci.org/redhat"
		key "RPM-GPG-KEY-jenkins"
	end

when "ubuntu"
	include_recipe "apt"
	apt_repository "jenkins" do
		uri "http://pkg.jenkins-ci.org/debian"
		components ["binary/"]
		key "http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key"
		notifies :run, resources(:execute => "apt-get update"), :immediately
	end
end

package "jenkins" do
  action :install
end

# Install Jenkins config file.
template "#{node[:jenkins][:config]}" do
  source "jenkins.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :home              => node[:jenkins][:home],
    :java_cmd          => node[:jenkins][:java_cmd],
    :user              => node[:jenkins][:user],
    :java_options      => node[:jenkins][:java_options],
    :port              => node[:jenkins][:port],
    :ajp_port          => node[:jenkins][:ajp_port],
    :debug_level       => node[:jenkins][:debug_level],
    :enable_access_log => node[:jenkins][:enable_access_log],
    :handler_max       => node[:jenkins][:handler_max],
    :handler_idle      => node[:jenkins][:handler_idle],
    :args              => node[:jenkins][:args]
  }) 
end

# Install iptables NAT rule to forward port 80 traffic to the listening Jenkins port.
template "/etc/iptables.snat" do
  source "iptables.snat.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :port => node[:jenkins][:port]
  })
end

# Allow inbound traffic to the listening Jenkins port.
template "/etc/iptables.d/port_#{node[:jenkins][:port]}_any_tcp" do
  source "iptables_jenkins_port.erb"
  owner "root"
  group "root"
  mode "0644"
  variables({
    :port => node[:jenkins][:port]
  })
end

# Re-run rebuild-iptables to ensure that the rules are up to date.
execute "rebuild_iptables_rules" do
  command "rebuild-iptables"
  action :run
end

service "jenkins" do
  action [ :enable, :restart ]
end

rightscale_marker :end
