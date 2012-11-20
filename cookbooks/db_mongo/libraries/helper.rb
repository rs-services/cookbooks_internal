#
# Cookbook Name:: db_mongo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Database
    module Mongo
      module Helper

        require 'timeout'
        require 'yaml'
        require 'ipaddr'

        SNAPSHOT_POSITION_FILENAME = 'rs_snapshot_position.yaml'
        DEFAULT_CRITICAL_TIMEOUT = 7

        # Create new MySQL object
        #
        # @param [Object] new_resource Resource which will be initialized
        #
        # @return [Mysql] MySQL object
        def init(new_resource)
          begin
            require 'rightscale_tools'
          rescue LoadError
            Chef::Log.warn "  This database cookbook requires our 'rightscale_tools' gem."
            Chef::Log.warn "  Please contact Rightscale to upgrade your account."
          end
          mount_point = new_resource.name
          RightScale::Tools::Database.factory(version, new_resource.user, new_resource.password, mount_point, Chef::Log)
        end


        #Helper to determing if node is master.
        def isMaster(node)
          # `mongo --eval "db.isMaster()"`
        #db.isMaster();
        
        
        end



















        # Create numeric UUID
        # MySQL server_id must be a unique number  - use the ip address integer representation
        #
        # Duplicate IP's and server_id's may occur with cross cloud replication.
        def self.mycnf_uuid(node)
          node[:db_mysql][:mycnf_uuid] = IPAddr.new(node[:cloud][:private_ips][0]).to_i
        end

        # Generate unique filename for relay_log used in slave db.
        # Should only generate once.  Used to create unique relay_log files used for slave
        # Always set to support stop/start
        def self.mycnf_relay_log(node)
          node[:db_mysql][:mycnf_relay_log] = Time.now.to_i.to_s + rand(9999).to_s.rjust(4,'0') if !node[:db_mysql][:mycnf_relay_log]
          return node[:db_mysql][:mycnf_relay_log]
        end

   
        def self.load_replication_info(node)
          loadfile = ::File.join(node[:db][:data_dir], SNAPSHOT_POSITION_FILENAME)
          Chef::Log.info "  Loading replication information from #{loadfile}"
          YAML::load_file(loadfile)
        end

       
        def self.load_master_info_file(node)

        end

      
        def self.get_mysql_handle(node, hostname = 'localhost')

        end

       
        def self.do_query(node, query, hostname = 'localhost', timeout = nil, tries = 1)

        end

        def self.reconfigure_replication(node, hostname = 'localhost', newmaster_host = nil, newmaster_logfile=nil, newmaster_position=nil)

        end
      end
    end
  end
end
