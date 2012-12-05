#
# RightScale Tools
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

require 'fileutils'

module RightScale
  module Tools
    class DatabaseMysql < RightScale::Tools::Database
      
      include FileUtils::Verbose
              
      def initialize(user, passwd, data_dir, timeout, max_attempts, logger=Logger(stdout))
        require 'rightscale_tools/premium/db/common/d_b_utils'
        require 'mysql'
        super("MySQL", user, passwd, data_dir, timeout, max_attempts, logger)
        @db = create_shared_premium_util
      end  
      
      def start
        @log.info "Starting database..."
        @db.ensure_db_up_with_binlog
      end
      
      def move_datadir(datadir_dst, datadir_src)
        unless ::File.symlink?(datadir_src)
          files = Dir.glob(datadir_src+"/*")
          FileUtils.cp_r files, datadir_dst+"/."
          FileUtils.chown_R("mysql", "mysql", "#{datadir_dst}")
          FileUtils.rm_rf(datadir_src)
          File.symlink(datadir_dst, datadir_src)
          FileUtils.chown_R("mysql", "mysql", "#{datadir_src}")
        end
      end
    
      def reset(datadir_dst, datadir_src)
        stop
        `killall -s 9 -q -r 'mysql.*' || true`
        FileUtils.rm_rf(LOCK_PID_FILE)
        FileUtils.rm_rf(backup_touch_filename)
        FileUtils.rm_rf(datadir_dst)
        FileUtils.rm_rf(datadir_src)
        @log.info `/usr/bin/mysql_install_db --basedir=/usr --user=mysql`
      end
      
      def set_privileges(preset = "administrator", username = nil, password = nil, db_name = "*.*")
        
        # Open database connection and santize our inputs
        con = @db.get_connection
        username = con.escape_string(username)
        password = con.escape_string(password)
        db_name = con.escape_string(db_name)

        case priv_preset
        when 'administrator'
          con.query("GRANT ALL PRIVILEGES on #{db_name} TO '#{username}'@'%' IDENTIFIED BY '#{password}' WITH GRANT OPTION")
          con.query("GRANT ALL PRIVILEGES on #{db_name} TO '#{username}'@'localhost' IDENTIFIED BY '#{password}' WITH GRANT OPTION")
        when 'user'
          con.query("GRANT ALL PRIVILEGES on #{db_name} TO '#{username}'@'%' IDENTIFIED BY '#{password}'")
          con.query("GRANT ALL PRIVILEGES on #{db_name} TO '#{username}'@'localhost' IDENTIFIED BY '#{password}'")
          con.query("REVOKE SUPER on *.* FROM '#{username}'@'%' IDENTIFIED BY '#{password}'")
          con.query("REVOKE SUPER on *.* FROM '#{username}'@'localhost' IDENTIFIED BY '#{password}'")
        else
          raise "only 'administrator' and 'user' type presets are supported!"
        end

        con.query("FLUSH PRIVILEGES")
        con.close
      end
      
      # Get DB handle object
      # Extracted from db_mysql/libraries/helper.rb
      # Orig used Chef::Log and had node as arg
      #
      # === Parameters
      # host(String):: Hostname of server holding database
      #
      # === Return
      # con(Mysql):: Mysql handle
      def get_connection(host = @host)
        info_msg = "MySQL connection to #{host}"
        info_msg << ": opening NEW MySQL connection."
        con = Mysql.new(@host, @user, @password)
        @log.info(info_msg)
        # this raises if the connection has gone away
        con.ping
        return con
      end
      
      # Send DB query and return results
      #
      # === Parameters
      # query(String):: Query string to send to DB
      # hostname(String):: Hostname of server holding database
      # timeout(Int):: Timeout in seconds for query request
      # attempts(Int):: Number of attempts after timeout
      #
      # === Return
      # result(Hash):: DB output to query
      def do_query(query, hostname = 'localhost', timeout = nil, attempts = 1)
        count = 0
        while(count < attempts) do
          begin
           info_msg = "Doing SQL Query: HOST=#{hostname}, QUERY=#{query}"
           info_msg << ", TIMEOUT=#{timeout}" if timeout
           info_msg << ", NUM_TRIES=#{attempts}" if attempts > 1
           @log.info(info_msg)
           result = nil
           if timeout
             SystemTimer.timeout_after(timeout) do
               con = get_connection(hostname)
               result = con.query(query)
             end
           else
             con = get_connection(hostname)
             result = con.query(query)
           end
           return result.fetch_hash if result
           return result
          rescue Exception => e
            is_timeout = (e == Timeout::Error)
            @log.info("Timeout occurred during mysql query:#{e}") if is_timeout
            @log.info("Unexpected exception: #{e.message}") unless is_timeout
            count += 1
            if (count >= attempts)
              raise "FATAL: retry count reached"
            else
              @log.info("Retrying attempt #{count} of #{attempts}")
            end
          end
        end
      end
      
      def write_backup_info_file(master_uuid, master_ip, is_master)
        masterstatus = Hash.new
        masterstatus = do_query('SHOW MASTER STATUS')
        masterstatus['Master_IP'] = node[:db_mysql][:current_master_ip]
        masterstatus['Master_instance_uuid'] = node[:db_mysql][:current_master_uuid]
        slavestatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW SLAVE STATUS')
        slavestatus ||= Hash.new
        if node[:db_mysql][:this_is_master]
          Chef::Log.info "Backing up Master info"
        else
          Chef::Log.info "Backing up slave replication status"
          masterstatus['File'] = slavestatus['Relay_Master_Log_File']
          masterstatus['Position'] = slavestatus['Exec_Master_Log_Pos']
        end
        Chef::Log.info "Saving master info...:\n#{masterstatus.to_yaml}"
        ::File.open(::File.join(node[:db][:data_dir], RightScale::Database::MySQL::Helper::SNAPSHOT_POSITION_FILENAME), ::File::CREAT|::File::TRUNC|::File::RDWR) do |out|
          YAML.dump(masterstatus, out)
        end
      end


      # == Internal Methods
      #
      # The following methods are internal utils used by the above "step" methods and are not
      # intended to be used outside this class.
      #
      protected
    
      def is_pristine?
        @db.is_mysql_pristine?(nil, get_file_config) 
      end
      
      private
      
      # Instantiates our premium DB tools class
      #
      # This is out premium DBtools class that is shared with our RightScript 
      # based 11H1 ServerTemplates.
      #
      # See the premium/README.rdoc for more information.
      #
      def create_shared_premium_util
        require 'rightscale_tools/premium/db/common/d_b_utils_mysql'
        RightScale::DBUtilsMysql.new
      end

    end
  end
end

