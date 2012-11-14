#
# Cookbook Name:: db_mongo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

include RightScale::Database::Helper
include RightScale::Database::Mongo::Helper

action :stop do
  bash "start-service" do
    code <<-EOF
      service #{node[:mongo][:service]} stop
    EOF
    flags "-ex"
  end
end

action :start do
  bash "start-service" do
    code <<-EOF
      service #{node[:mongo][:service]} start
    EOF
    flags "-ex"
  end
end

action :restart do
  bash "start-service" do
    code <<-EOF
      service #{node[:mongo][:service]} restart
    EOF
    flags "-ex"
  end
end

action :status do
  @db = init(new_resource)
  status = @db.status
  log "  Database Status:\n#{status}"
end

action :lock do
  @db = init(new_resource)
  @db.lock
end

action :unlock do
  @db = init(new_resource)
  @db.unlock
end

action :move_data_dir do
  @db = init(new_resource)
  @db.move_datadir
end

action :reset do
  @db = init(new_resource)
  @db.reset
end

action :firewall_update_request do
  sys_firewall "Sending request to open port 3306 (Mongo) allowing this server to connect" do
    machine_tag new_resource.machine_tag
    port 27017
    enable new_resource.enable
    ip_addr new_resource.ip_addr
    action :update_request
  end
end

action :firewall_update do
  sys_firewall "Opening port 3306 (Mongo) for tagged '#{new_resource.machine_tag}' to connect" do
    machine_tag new_resource.machine_tag
    port 27017
    enable new_resource.enable
    action :update
  end
end


action :write_backup_info do
=begin
  db_state_get node
  masterstatus = Hash.new
  masterstatus = RightScale::Database::Mongo::Helper.do_query(node, 'SHOW MASTER STATUS')
  masterstatus['Master_IP'] = node[:db][:current_master_ip]
  masterstatus['Master_instance_uuid'] = node[:db][:current_master_uuid]
  slavestatus = RightScale::Database::Mongo::Helper.do_query(node, 'SHOW SLAVE STATUS')
  slavestatus ||= Hash.new
  if node[:db][:this_is_master]
    log "  Backing up Master info"
  else
    log "  Backing up slave replication status"
    masterstatus['File'] = slavestatus['Relay_Master_Log_File']
    masterstatus['Position'] = slavestatus['Exec_Master_Log_Pos']
  end

  # Save the db provider (Mongo) and version number as set in the node
  version=node[:db_mongo][:version]
  provider=node[:db][:provider]
  log "  Saving #{provider} version #{version} in master info file"
  masterstatus['DB_Provider']=provider
  masterstatus['DB_Version']=version

  log "  Saving master info...:\n#{masterstatus.to_yaml}"
  ::File.open(::File.join(node[:db][:data_dir], RightScale::Database::Mongo::Helper::SNAPSHOT_POSITION_FILENAME), ::File::CREAT|::File::TRUNC|::File::RDWR) do |out|
    YAML.dump(masterstatus, out)
  end
=end
end

action :pre_restore_check do
=begin
  @db = init(new_resource)
  @db.pre_restore_sanity_check
=end
end

action :post_restore_cleanup do
=begin
  # Performs checks for snapshot compatibility with current server
  ruby_block "validate_backup" do
    block do
      master_info = RightScale::Database::Mongo::Helper.load_replication_info(node)
      # Check version matches
      # Not all 11H2 snapshots (prior to 5.5 release) saved provider or version.
      # Assume Mongo 5.1 if nil
      snap_version=master_info['DB_Version']||='5.1'
      snap_provider=master_info['DB_Provider']||='db_mysql'
      current_version= node[:db_mongo][:version]
      current_provider=master_info['DB_Provider']||=node[:db][:provider]
      Chef::Log.info "  Snapshot from #{snap_provider} version #{snap_version}"
      # skip check if restore version check is false
      if node[:db][:backup][:restore_version_check] == "true"
        raise "FATAL: Attempting to restore #{snap_provider} #{snap_version} snapshot to #{current_provider} #{current_version} with :restore_version_check enabled." unless ( snap_version == current_version ) && ( snap_provider == current_provider )
      else
        Chef::Log.info "  Skipping #{provider} restore version check"
      end
    end
  end

  @db = init(new_resource)
  @db.symlink_datadir("/var/lib/mysql", node[:db][:data_dir])
  @db.post_restore_cleanup
=end
end

action :pre_backup_check do
=begin
  @db = init(new_resource)
  @db.pre_backup_check
=end
end

action :post_backup_cleanup do
=begin
  @db = init(new_resource)
  @db.post_backup_steps
=end
end

action :set_privileges do
=begin
  priv = new_resource.privilege
  priv_username = new_resource.privilege_username
  priv_password = new_resource.privilege_password
  priv_database = new_resource.privilege_database
  db_mysql_set_privileges "setup db privileges" do
    preset priv
    username priv_username
    password priv_password
    database priv_database
  end
=end
end

action :install_client do

  package "numactl" do
    action :install
  end

  remote_file "/tmp/mongodb.tar.gz" do
    source node[:mongo][:source]
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

  user node[:mongo][:user] do
    action :create
  end

  directory node[:mongo][:install_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  bash "extract-mongo" do
    cwd "/"
    code <<-EOF
      tar -xzf /tmp/mongodb.tar.gz -C #{node[:mongo][:install_dir]} --strip-components=1
    EOF
  end

  directory node[:mongo][:data_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  directory node[:mongo][:log_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  %w{mongo mongod mongodump mongoexport mongofiles mongoimport mongorestore mongos mongotop mongosniff mongostat}.each do |binary|
    link "/usr/bin/#{binary}" do
      to "#{node[:mongo][:install_dir]}/bin/#{binary}"
      link_type :symbolic
      action :create
    end
  end

end

action :install_server do
  package "numactl" do
    action :install
  end

  remote_file "/tmp/mongodb.tar.gz" do
    source node[:mongo][:source]
    owner "root"
    group "root"
    mode "0644"
    action :create
  end

  user node[:mongo][:user] do
    action :create
  end

  directory node[:mongo][:install_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  bash "extract-mongo" do
    cwd "/"
    code <<-EOF
      tar -xzf /tmp/mongodb.tar.gz -C #{node[:mongo][:install_dir]} --strip-components=1
  EOF
  end

  directory node[:mongo][:data_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  directory node[:mongo][:log_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0755
    recursive true
    action :create
  end

  %w{mongo mongod mongodump mongoexport mongofiles mongoimport mongorestore mongos mongotop mongosniff mongostat}.each do |binary|
    link "/usr/bin/#{binary}" do
      to "#{node[:mongo][:install_dir]}/bin/#{binary}"
      link_type :symbolic
      action :create
    end
  end

  template "#{node[:mongo][:conf_file]}" do
    cookbook "db_mongo"
    source "mongo.conf.erb"
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0777
    variables( :db_path => node[:mongo][:data_dir],
               :pid_file => "#{node[:mongo][:pid_dir]}/#{node[:mongo][:service]}.pid",
               :port => node[:mongo][:port],
               :web_admin_port => node[:mongo][:web_admin_port],
               :replSet => node[:mongo][:replSet] )
    action :create
  end

  template "/etc/init.d/#{node[:mongo][:service]}" do
    cookbook "db_mongo"
    source "mongodb-init.erb"
    owner "root"
    group "root"
    mode "0777"
    variables( :db_path => node[:mongo][:data_dir] )
    action :create
  end

  directory node[:mongo][:pid_dir] do
    owner node[:mongo][:user]
    group node[:mongo][:user]
    mode 0777
    action :create
  end

  service node[:mongo][:service] do
    action [ :enable ]
  end

  sys_firewall node[:mongo][:web_admin_port] do
    action :update
  end

  if !node[:mongo][:replSet].nil?
    log node[:mongo][:replSet]
    right_link_tag "mongo:replSet=#{node[:mongo][:replSet]}" do
      action :publish 
    end
    right_link_tag "mongo:port=#{node[:mongo][:port]}" do
      action :publish 
    end
  end

  db node[:db][:data_dir] do
    action :start
    persist false
  end
end

action :setup_monitoring do
=begin
  db_state_get node

  ruby_block "evaluate db type" do
    block do
      if node[:db][:init_status].to_sym == :initialized
        node[:db_mongo][:collectd_master_slave_mode] = ( node[:db][:this_is_master] == true ? "Master" : "Slave" ) + "Stats true"
      else
        node[:db_mongo][:collectd_master_slave_mode] = ""
      end
    end
  end

  service "collectd" do
    action :nothing
  end

  platform = node[:platform]
  collectd_version = node[:rightscale][:collectd_packages_version]
  # Centos specific items
  collectd_version = node[:rightscale][:collectd_packages_version]
  package "collectd-mysql" do
    action :install
    version "#{collectd_version}" unless collectd_version == "latest"
    only_if { platform =~ /redhat|centos/ }
  end

  template ::File.join(node[:rightscale][:collectd_plugin_dir], 'mysql.conf') do
    source "collectd-plugin-mysql.conf.erb"
    mode "0644"
    backup false
    cookbook 'db_mysql'
    notifies :restart, resources(:service => "collectd")
  end

  # Send warning if not centos/redhat or ubuntu
  log "  WARNING: attempting to install collectd-mysql on unsupported platform #{platform}, continuing.." do
    not_if { platform =~ /centos|redhat|ubuntu/ }
    level :warn
  end
=end
end

action :grant_replication_slave do
=begin
  require 'mysql'

  Chef::Log.info "GRANT REPLICATION SLAVE to #{node[:db][:replication][:user]}"
  con = Mysql.new('localhost', 'root')
  con.query("GRANT REPLICATION SLAVE ON *.* TO '#{node[:db][:replication][:user]}'@'%' IDENTIFIED BY '#{node[:db][:replication][:password]}'")
  con.query("FLUSH PRIVILEGES")
  con.close
=end
end

action :promote do
=begin
  db_state_get node

  x = node[:db_mongo][:log_bin]
  logbin_dir = x.gsub(/#{::File.basename(x)}$/, "")
  directory logbin_dir do
    action :create
    recursive true
    owner 'mysql'
    group 'mysql'
  end

  # Set read/write in my.cnf
  node[:db_mongo][:tunable][:read_only] = 0
  # Enable binary logging in my.cnf
  node[:db_mongo][:log_bin_enabled] = true

  # Setup my.cnf
  db_mysql_set_mycnf "setup_mycnf" do
    server_id RightScale::Database::Mongo::Helper.mycnf_uuid(node)
    relay_log RightScale::Database::Mongo::Helper.mycnf_relay_log(node)
  end

  db node[:db][:data_dir] do
    action :start
    persist false
    only_if do
      log_bin = RightScale::Database::Mongo::Helper.do_query(node, "show variables like 'log_bin'", 'localhost', RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT)
      if log_bin['Value'] == 'OFF'
        Chef::Log.info "  Detected binlogs were disabled, restarting service to enable them for Master takeover."
        true
      else
      	false
      end
    end
  end

  RightScale::Database::Mongo::Helper.do_query(node, "SET GLOBAL READ_ONLY=0", 'localhost', RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT)
  newmasterstatus = RightScale::Database::Mongo::Helper.do_query(node, 'SHOW SLAVE STATUS', 'localhost', RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT)
  previous_master = node[:db][:current_master_ip]
  raise "FATAL: could not determine master host from slave status" if previous_master.nil?
  Chef::Log.info "  host: #{previous_master}}"

  # PHASE1: contains non-critical old master operations, if a timeout or
  # error occurs we continue promotion assuming the old master is dead.
  begin
    # OLDMASTER: query with terminate (STOP SLAVE)
    RightScale::Database::Mongo::Helper.do_query(node, 'STOP SLAVE', previous_master, RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT, 2)

    # OLDMASTER: flush_and_lock_db
    RightScale::Database::Mongo::Helper.do_query(node, 'FLUSH TABLES WITH READ LOCK', previous_master, 5, 12)


    # OLDMASTER:
    masterstatus = RightScale::Database::Mongo::Helper.do_query(node, 'SHOW MASTER STATUS', previous_master, RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT)

    # OLDMASTER: unconfigure source of replication
    RightScale::Database::Mongo::Helper.do_query(node, "CHANGE MASTER TO MASTER_HOST=''", previous_master, RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT)

    master_file=masterstatus['File']
    master_position=masterstatus['Position']
    Chef::Log.info "  Retrieved master info...File: " + master_file + " position: " + master_position

    Chef::Log.info "  Waiting for slave to catch up with OLDMASTER (if alive).."
    # NEWMASTER localhost:
    RightScale::Database::Mongo::Helper.do_query(node, "SELECT MASTER_POS_WAIT('#{master_file}',#{master_position})")
  rescue => e
    Chef::Log.info "  WARNING: caught exception #{e} during non-critical operations on the OLD MASTER"
  end

  # PHASE2: reset and promote this slave to master
  # Critical operations on newmaster, if a failure occurs here we allow it to halt promote operations
  Chef::Log.info "  Promoting slave.."
  RightScale::Database::Mongo::Helper.do_query(node, 'RESET MASTER')

  newmasterstatus = RightScale::Database::Mongo::Helper.do_query(node, 'SHOW MASTER STATUS')
  newmaster_file=newmasterstatus['File']
  newmaster_position=newmasterstatus['Position']
  Chef::Log.info "  Retrieved new master info...File: " + newmaster_file + " position: " + newmaster_position

  Chef::Log.info "  Stopping slave and misconfiguring master"
  RightScale::Database::Mongo::Helper.do_query(node, "STOP SLAVE")
  RightScale::Database::Mongo::Helper.do_query(node, "RESET SLAVE")
  action_grant_replication_slave
  RightScale::Database::Mongo::Helper.do_query(node, 'SET GLOBAL READ_ONLY=0')

  # PHASE3: more non-critical operations, have already made assumption oldmaster is dead
  begin
    unless previous_master.nil?
      # Unlocking oldmaster
      RightScale::Database::Mongo::Helper.do_query(node, 'UNLOCK TABLES', previous_master)
      SystemTimer.timeout_after(RightScale::Database::Mongo::Helper::DEFAULT_CRITICAL_TIMEOUT) do
      # Demote oldmaster
        Chef::Log.info "  Calling reconfigure replication with host: #{previous_master} ip: #{node[:cloud][:private_ips][0]} file: #{newmaster_file} position: #{newmaster_position}"
        RightScale::Database::Mongo::Helper.reconfigure_replication(node, previous_master, node[:cloud][:private_ips][0], newmaster_file, newmaster_position)
      end
    end
  rescue Timeout::Error => e
    Chef::Log.info("  WARNING: rescuing SystemTimer exception #{e}, continuing with promote")
  rescue => e
    Chef::Log.info("  WARNING: rescuing exception #{e}, continuing with promote")
  end
=end
end


action :enable_replication do
  db_state_get node
  current_restore_process = new_resource.restore_process
  require 'mongo'
  results = rightscale_server_collection "mongo_replicas" do
    tags ["mongo:replSet=#{node[:mongo][:replSet]}"]
    secondary_tags ["server:private_ip_0=*"]
    empty_ok false
    action :nothing
  end

  results.run_action(:load)
  str_json="{ _id: '#{node[:mongo][:replSet]}', members: ["
  i=0
  if node["server_collection"]["mongo_replicas"]
    log "Server Collection Found"
    node["server_collection"]["mongo_replicas"].to_hash.values.each do |tags|
      repl_ip=RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
      repl_port=RightScale::Utils::Helper.get_tag_value("mongo:port", tags)
      str_json+="{_id: #{i}, host: '#{repl_ip}:#{repl_port}'},"
      i+=1
    end
  end
  str_json+=" ] }"
  #connection = Mongo::Connection.new("localhost", 27017)
  #db=connection.db("local")
  log str_json
  #db.command({ replSetInitiates : str_json })
  `mongo --eval "printjson(rs.initiate(#{str_json}))"`
  raise "Replica set was not configured" unless $?.exitstatus == 0
end

action :generate_dump_file do
=begin
  db_name     = new_resource.db_name
  dumpfile    = new_resource.dumpfile

  execute "Write the mysql DB backup file" do
    command "mysqldump --single-transaction -u root #{db_name} | gzip -c > #{dumpfile}"
  end
=end
end

action :restore_from_dump_file do
=begin
  db_name   = new_resource.db_name
  dumpfile  = new_resource.dumpfile
  db_check  = `mysql -e "SHOW DATABASES LIKE '#{db_name}'"`

  log "  Check if DB already exists"
  ruby_block "checking existing db" do
    block do
      if ! db_check.empty?
        Chef::Log.warn "  WARNING: database '#{db_name}' already exists. No changes will be made to existing database."
      end
    end
  end

  bash "Import Mongo dump file: #{dumpfile}" do
    only_if { db_check.empty? }
    user "root"
    flags "-ex"
    code <<-EOH
      if [ ! -f #{dumpfile} ]
      then
        echo "ERROR: Mongo dumpfile not found! File: '#{dumpfile}'"
        exit 1
      fi
      mysqladmin -u root create #{db_name}
      gunzip < #{dumpfile} | mysql -u root -b #{db_name}
    EOH
  end
=end
end
