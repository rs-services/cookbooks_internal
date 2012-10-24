#
# Cookbook Name:: sys_firewall
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin
include_recipe 'iptables'
include_recipe 'sys_firewall'
# convert inputs into parameters usable by the firewall_rule definition
# TODO add support for 'any' and port ranges '80,8000,3000-4000'
rule_port = 1521
raise "Invalid port specified: #{node[:sys_firewall][:rule][:port]}.  Valid range 1-65536" unless rule_port > 0 and rule_port <= 65536
rule_ip = 'any'
rule_ip = (rule_ip == "" || rule_ip.downcase =~ /any/ ) ? nil : rule_ip 
rule_protocol = 'tcp'

if node[:sys_firewall][:enabled] == "enabled"

  sys_firewall rule_port do
    ip_addr rule_ip
    protocol rule_protocol
    enable true
    action :update
  end

else 
  log "Firewall not enabled. Not adding rule for #{rule_port}."
end

rightscale_marker :end
