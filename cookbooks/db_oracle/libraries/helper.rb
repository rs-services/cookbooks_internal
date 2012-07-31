#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Database
    module Oracle
      module Helper

        require 'timeout'
        require 'yaml'
        require 'ipaddr'

        SNAPSHOT_POSITION_FILENAME = 'rs_snapshot_position.yaml'
        DEFAULT_CRITICAL_TIMEOUT = 7

        # Create new Oracle object
        #
        # @param [Object] new_resource Resource which will be initialized
        #
        # @return [Oracle] Oracle object
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

        # Create numeric UUID
        # Oracle server_id must be a unique number  - use the ip address integer representation
        #
        # Duplicate IP's and server_id's may occur with cross cloud replication.
        def self.mycnf_uuid(node)
          node[:db_oracle][:ora_uuid] = IPAddr.new(node[:cloud][:private_ips][0]).to_i
        end

        # Helper to load replication information
        # from "rs_snapshot_position.yaml"
        #
        # @param [Hash] node  Node name
        def self.load_replication_info(node)
          loadfile = ::File.join(node[:db][:data_dir], SNAPSHOT_POSITION_FILENAME)
          Chef::Log.info "  Loading replication information from #{loadfile}"
          YAML::load_file(loadfile)
        end

        # Loading information about replication master status.
        # If that file exists, the Oracle server has already previously been configured for replication,
        #
        # @param [Hash] node  Node name
        def self.load_master_info_file(node)
          loadfile = ::File.join(node[:db][:data_dir], "master.info")
          Chef::Log.info "  Loading master.info file from #{loadfile}"
          file_contents = File.readlines(loadfile)
          file_contents.each {|f| f.rstrip!}
          master_info = Hash.new
          master_info["File"] = file_contents[1]
          master_info["Position"] = file_contents[2]
          master_info["Master_IP"] = file_contents[3]
          return master_info
        end

        # Create new Oracle connection
        #
        # @param [Hash] node Node name
        # @param [String] hostname Hostname FQDN, default is 'localhost'
        #
        # @return [Oracle] Oracle connection
        def self.get_oracle_handle(node, hostname = 'localhost')
          require 'oci8'
          #require '/opt/oracle/.ora_creds/ora_creds.rb'
          #ora_conn = OCI8.new(@user, @pass, nil, :SYSDBA)
          info_msg = "  Oracle connection to #{hostname}"
          info_msg << ": opening NEW Oracle connection."
          con = OCI8.new(hostname, node[:db][:admin][:user], node[:db][:admin][:password])
          Chef::Log.info info_msg
          # this raises if the connection has gone away
          con.ping
          return con
        end

        # Perform sql query to Oracle server
        #
        # @param [Hash] node Node name
        # @param [String] hostname Hostname FQDN, default is 'localhost'
        # @param [Integer] timeout Timeout value
        # @param [Integer] tries Connection attempts number
        #
        # @return [Mysql::Result] Oracle query result
        #
        # @raises [TimeoutError] if timeout exceeded
        # @raises [RuntimeError] if connection try attempts limit reached
        def self.do_query(node, query, hostname = 'localhost', timeout = nil, tries = 1)
          require 'oci8'

          loop do
            begin
              info_msg = "  Doing SQL Query: HOST=#{hostname}, QUERY=#{query}"
              info_msg << ", TIMEOUT=#{timeout}" if timeout
              info_msg << ", NUM_TRIES=#{tries}" if tries > 1
              Chef::Log.info info_msg
              result = nil
              if timeout
                SystemTimer.timeout_after(timeout) do
                  con = get_mysql_handle(node, hostname)
                  result = con.exec(query)
                end
              else
                con = get_mysql_handle(node, hostname)
                result = con.query(query)
              end
              return result.fetch_hash if result
              return result
            rescue Timeout::Error => e
              Chef::Log.info("  Timeout occured during mysql query:#{e}")
              tries -= 1
              raise "FATAL: retry count reached" if tries == 0
            end
          end
        end

        # Replication process reconfiguration
        #
        # @param [Hash] node Node name
        # @param [String] hostname Hostname FQDN, default is 'localhost'
        # @param [String] newmaster_host FQDN or ip of new replication master
        # @param [String] newmaster_logfile Replication log filename
        # @param [Integer] newmaster_position Last record position in replication log
        def self.reconfigure_replication(node, hostname = 'localhost', newmaster_host = nil, newmaster_logfile=nil, newmaster_position=nil)
          Chef::Log.info "Not Implemented"
          =begin
          Chef::Log.info "  Configuring with #{newmaster_host} logfile #{newmaster_logfile} position #{newmaster_position}"

          # The slave stop can fail once (only throws warning if slave is already stopped)
          2.times do
            RightScale::Database::Oracle::Helper.do_query(node, "STOP SLAVE", hostname)
          end

          cmd = "CHANGE MASTER TO MASTER_HOST='#{newmaster_host}'"
          cmd +=   ", MASTER_LOG_FILE='#{newmaster_logfile}'" if newmaster_logfile
          cmd +=   ", MASTER_LOG_POS=#{newmaster_position}" if newmaster_position
          Chef::Log.info "Reconfiguring replication on localhost: \n#{cmd}"
          # don't log replication user and password
          cmd +=   ", MASTER_USER='#{node[:db][:replication][:user]}'"
          cmd +=   ", MASTER_PASSWORD='#{node[:db][:replication][:password]}'"
          RightScale::Database::Oracle::Helper.do_query(node, cmd, hostname)

          RightScale::Database::Oracle::Helper.do_query(node, "START SLAVE", hostname)
          started=false
          10.times do
            row = RightScale::Database::Oracle::Helper.do_query(node, "SHOW SLAVE STATUS", hostname)
            slave_IO = row["Slave_IO_Running"].strip.downcase
            slave_SQL = row["Slave_SQL_Running"].strip.downcase
            if( slave_IO == "yes" and slave_SQL == "yes" ) then
              started=true
              break
            else
              Chef::Log.info "  Threads at new slave not started yet...waiting a bit more..."
              sleep 2
            end
          end
          if( started )
            Chef::Log.info "  Slave threads on the master are up and running."
          else
            Chef::Log.info "  Error: slave threads in the master do not seem to be up and running..."
          end
        end
        =end
      end
    end
  end
end
