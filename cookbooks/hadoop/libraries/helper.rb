#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Hadoop
    module Helper
            
      def set_node_type_tag(type)
        right_link_tag "hadoop:node_type=#{type}"
      end
      
      # get a list of hosts from the server tags
      def get_hosts(type) 
        hadoop_servers = Set.new
        
        r=  rightscale_server_collection "hosts" do
          tags ["hadoop:node_type=#{type}"]
          empty_ok false
          timeout 120
          action :nothing
        end
        r.run_action(:load)
        
        log "HOSTS: #{node[:server_collection]['hosts'].inspect}"
        node[:server_collection]['hosts'].to_hash.values.each do |tags|
          ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
          hadoop_servers.add?(ip)
        end    
        hadoop_servers
      end
      
      # Add public key for root to ssh to itself as needed by hadoop.
      #
      # @param public_ssh_key [string] public key to add
      #
      # @raises [RuntimeError] if ssh key string is empty
      def add_public_key(public_ssh_key)
        Chef::Log.info("  Updating authorized_keys ")
       
        directory "/root/.ssh" do
          mode "0700"
          recursive true
          action :create
        end
        
        file "/root/.ssh/authorized_keys" do
          mode "0600"
          action :create_if_missing
        end       
        
        if "#{public_ssh_key}" != ""
          ruby_block "create_authorized_keys" do
            block do
              # Writing key to file
              system("echo '#{public_ssh_key}' >> /root/.ssh/authorized_keys")
              # Setting permissions
              system("chmod 0600 /root/.ssh/authorized_keys")
            end
          end
        else
          raise "  Missing Public ssh key"
        end
    
      end
    end
  end
end