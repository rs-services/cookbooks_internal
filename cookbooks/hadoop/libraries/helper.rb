#
# Cookbook Name:: Hadoop
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Hadoop
    module Helper
            
      # get a list of hosts from the server tags
      def get_hosts(type) 
        hadoop_servers = Set.new
        
        r=  server_collection "hosts" do
          tags "hadoop:node_type=datanode"
          action :nothing
        end
        r.run_action(:load)

        node[:server_collection]['hosts'].to_hash.values.each do |tags|
          ip = RightScale::Utils::Helper.get_tag_value('server:private_ip_0', tags)
          hadoop_servers.add?(ip)
        end
        log "hosts #{hadoop_servers.inspect}"
        hadoop_servers
      end
      
    
    end
  end
end