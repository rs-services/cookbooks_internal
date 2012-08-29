#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

include RightScale::Database::Helper
include RightScale::Database::Oracle::Helper

action :stop do
  bash "stopping oracle service" do
    user "root"
    code <<-EOF
      su -l -c '/opt/oracle/app/product/11.2.0/dbhome_1/bin/dbshut' oracle
    EOF
  end
end

action :start do
  bash "starting oracle service" do
    user "root"
    code <<-EOF
      su -l -c '/opt/oracle/app/product/11.2.0/dbhome_1/bin/start' oracle
    EOF
  end
end

action :restart do
  self.stop
  self.start
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
  sys_firewall "Sending request to open port 1521 (Oracle) allowing this server to connect" do
    machine_tag new_resource.machine_tag
    port 1521
    enable new_resource.enable
    ip_addr new_resource.ip_addr
    action :update_request
  end
end

action :firewall_update do
  sys_firewall "Opening port 1521 (Oracle) for tagged '#{new_resource.machine_tag}' to connect" do
    machine_tag new_resource.machine_tag
    port 1521
    enable new_resource.enable
    action :update
  end
end


action :write_backup_info do
=begin
  db_state_get node
  masterstatus = Hash.new
  masterstatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW MASTER STATUS')
  masterstatus['Master_IP'] = node[:db][:current_master_ip]
  masterstatus['Master_instance_uuid'] = node[:db][:current_master_uuid]
  slavestatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW SLAVE STATUS')
  slavestatus ||= Hash.new
  if node[:db][:this_is_master]
    log "  Backing up Master info"
  else
    log "  Backing up slave replication status"
    masterstatus['File'] = slavestatus['Relay_Master_Log_File']
    masterstatus['Position'] = slavestatus['Exec_Master_Log_Pos']
  end

  # Save the db provider (Oracle) and version number as set in the node
  version=node[:db_oracle][:version]
  provider=node[:db][:provider]
  log "  Saving #{provider} version #{version} in master info file"
  masterstatus['DB_Provider']=provider
  masterstatus['DB_Version']=version

  log "  Saving master info...:\n#{masterstatus.to_yaml}"
  ::File.open(::File.join(node[:db][:data_dir], RightScale::Database::MySQL::Helper::SNAPSHOT_POSITION_FILENAME), ::File::CREAT|::File::TRUNC|::File::RDWR) do |out|
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
      master_info = RightScale::Database::MySQL::Helper.load_replication_info(node)
      # Check version matches
      # Not all 11H2 snapshots (prior to 5.5 release) saved provider or version.
      # Assume MySQL 5.1 if nil
      snap_version=master_info['DB_Version']||='5.1'
      snap_provider=master_info['DB_Provider']||='db_oracle'
      current_version= node[:db_oracle][:version]
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
  admin_password = node[:db][:admin][:password]
  password = node[:db][:sys][:password]
  username = node[:db][:admin][:user]
  db_oracle_set_privileges "setup db privileges" do
    username username
    admin_password admin_password
    password password
  end
=begin
  bash "set-oracle-privs" do
    user "root"
    cwd "/"
    code <<-EOF
cat <<EOH> /tmp/privs.sql
grant DBA to SYSMAN;
grant MGMT_USER to SYSMAN with admin option;
grant ALTER SESSION to SYSMAN;
grant ALTER USER to SYSMAN;
grant CREATE ANY TABLE to SYSMAN;
grant CREATE USER to SYSMAN;
grant DROP USER to SYSMAN;
grant SELECT ANY DICTIONARY to SYSMAN;
grant UNLIMITED TABLESPACE to SYSMAN;
GRANT CREATE TABLESPACE TO SYSMAN;
ALTER SYSTEM SET open_cursors = 4000 SCOPE=BOTH;
CREATE USER  #{node[:db][:admin][:user]} IDENTIFIED BY #{node[:db][:admin][:password]};
GRANT SYSDBA TO #{node[:db][:admin][:user]};

COMMIT; 
EOH
su -l -c '/opt/oracle/app/product/11.2.0/dbhome_1/bin/sqlplus "/ as sysdba" @/tmp/privs.sql' oracle
su -l -c '/opt/oracle/app/product/11.2.0/dbhome_1/bin/dbshut' oracle
su -l -c '/opt/oracle/app/product/11.2.0/dbhome_1/bin/dbstart' oracle
    EOF
  end
=end
end

action :install_client do

  # Install Oracle client packages
  packages = node[:db_oracle][:client_packages_install]
  log "  Packages to install: #{packages.join(",")}" unless packages == ""
  packages.each do |p|
    r = package p do
      action :nothing
    end
    r.run_action(:install)
  end
  
  location = '/mnt/ephemeral/Oracle.Installers'
  directory location do
    owner "root"
    group "root"
    mode "0755"
    recursive true
    action :create
  end

  bash "downloading oracle.zip" do
    user "root"
    cwd location
    flags "-ex"
    code <<-EOF
  aria2c http://ps-cf.rightscale.com/oracle/linux.x64_11gR2_client.zip -x 16 -d #{location}
  unzip -q -u linux.x64_11gR2_client.zip
    EOF
  end


  sysctl "net.ipv4.ip_local_port_range" do
    value "1024 65535"
    action :set
  end

  template "#{location}/client.rsp" do
    cookbook "db_oracle"
    source "client.rsp.erb"
    owner "root"
    group "root"
    mode "0775"
    action :create
  end

  user "oracle" do
    comment "Oracle User"
    shell "/bin/bash"
    home "/opt/oracle"
  end

  directory "/opt/oracle" do
    owner "oracle"
    group "oracle"
    mode "0775"
    action :create
  end

  bash "oracle-install" do
    user "oracle"
    cwd "#{location}"
    flags "-x"
    code <<-EOF
      su -l -c '#{location}/client/runInstaller -silent -responseFile #{location}/client.rsp -waitforcompletion' oracle
      /opt/oracle/oraInventory/orainstRoot.sh
    EOF
  end

  template "/etc/profile.d/oracle_profile.sh" do
    cookbook "db_oracle"
    source "oracle_profile.sh.erb"
    owner "root"
    group "root"
    mode "0777"
    variables( :db_home => "client_1" )
    action :create
  end

  execute "/opt/oracle/app/product/11.2.0/client_1/root.sh" do
    creates "/etc/oratab"
    action :run
  end

  template "/opt/oracle/app/product/11.2.0/client_1/network/admin/tnsnames.ora" do
    cookbook "db_oracle"
    source "tnsnames.ora.erb"
    owner "root"
    group "root"
    mode "0777"
    variables( :db_server => node[:oracle][:server][:private_ip] )
    action :create
  end
end

action :install_server do
  log "Installing Oracle Server"
  platform = node[:platform]
  
  log "Downloading Oracle Files"
  directory "/mnt/ephemeral" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    not_if "test -e /mnt/ephemeral"
  end

  bash "download-disk-1" do
    user "root"
    cwd '/mnt/ephemeral'
    code <<-EOF
     aria2c #{node[:oracle][:install_file1_url]} -x 16 -d /mnt/ephemeral
    EOF
  end

  bash "extract" do
    user "root"
    cwd '/mnt/ephemeral'
    code <<-EOF
      unzip -q `basename #{node[:oracle][:install_file1_url]}`
      rm -fr `basename #{node[:oracle][:install_file1_url]}`
    EOF
  end

  bash "download-disk-2" do
    user "root"
    cwd '/mnt/ephemeral'
    code <<-EOF
      aria2c #{node[:oracle][:install_file2_url]} -x 16 -d /mnt/ephemeral
    EOF
  end
  bash "extract" do
    user "root"
    cwd '/mnt/ephemeral'
    code <<-EOF
      unzip -q `basename #{node[:oracle][:install_file2_url]}`
      rm -fr `basename #{node[:oracle][:install_file2_url]}`
    EOF
  end

  # Uninstall certain packages
  packages = node[:db_oracle][:server_packages_uninstall]
  log "  Packages to uninstall: #{packages.join(",")}" unless packages == ""
  packages.each do |p|
    package p do
      action :remove
    end
  end unless packages == ""
  
  packages = node[:db_oracle][:server_packages_install]
  log "  Packages to install: #{packages.join(",")}" unless packages == ""
  packages.each do |p|
    package p do
      action :install
    end
  end unless packages == ""

  link "/opt/oracle" do
    to "/mnt/storage"
    only_if "test -d /mnt/storage"
  end

  user "oracle" do 
    comment "Oracle User"
    shell "/bin/bash"
    home "/opt/oracle"
  end

  group "oinstall" do 
    members ['oracle']
    action :create
  end

  group "dba" do
    members ['oracle']
    action :create
  end

  group "oper" do
    members ['oracle']
    action :create
  end

  group "asmadmin" do
    members ['oracle']
    action :create
  end

  template "/mnt/ephemeral/database/db.rsp" do 
    cookbook "db_oracle"
    source "db.rsp.erb"
    mode "0755"
    variables(
      :starterdb_password_sys => node[:db][:sys][:password],
      :starterdb_password_system => node[:db][:system][:password],
      :starterdb_password_sysman => node[:db][:sysman][:password],
      :starterdb_password_dbsnmp => node[:db][:dbsnmp][:password]
    )
  end

  template "/etc/profile.d/oracle_profile.sh" do
    cookbook "db_oracle"
    source "oracle_profile.sh.erb"
    owner "root"
    group "root"
    mode "0777"
    variables( :db_home => "dbhome_1" )
    action :create
  end

  directory "/opt/oracle/inventory" do
    owner "oracle"
    group "oracle"
    mode "0775"
    action :create
  end

  directory "/mnt/ephemeral/oracle" do
    owner "oracle"
    group "oracle"
    mode "0775"
    action :create
  end

  directory "/mnt/ephemeral/oracle/starterdb" do
    owner "oracle"
    group "oracle"
    mode "0775"
    action :create
  end

  bash "oracle-system-update" do 
    user "root"
    cwd "/mnt/ephemeral/database/"
    code <<-EOF
cat <<EOH>> /etc/sysctl.conf
fs.suid_dumpable = 1
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 536870912
kernel.shmmni = 4096
# semaphores: semmsl, semmns, semopm, semmni
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default=4194304
net.core.rmem_max=4194304
net.core.wmem_default=262144
net.core.wmem_max=1048586
EOH
sysctl -p

cat <<EOH>> /etc/security/limits.conf
oracle              soft    nproc   2047
oracle              hard    nproc   16384
oracle              soft    nofile  4096
oracle              hard    nofile  65536
oracle              soft    stack   10240
EOH

yum install glibc-devel unixODBC -y -q
ldconfig
    EOF
  end

  bash "oracle-install" do 
    user "oracle"
    cwd "/mnt/ephemeral/database"
    code <<-EOF
su -l -c '/mnt/ephemeral/database/runInstaller -silent -responseFile /mnt/ephemeral/database/db.rsp -waitforcompletion' oracle
rm -fr /mnt/ephemeral/database
    EOF
  end

  bash "/opt/oracle/inventory/orainstRoot.sh" do
    user "root"
    code <<-EOF
    /opt/oracle/oraInventory/orainstRoot.sh
    EOF
  end

  bash "root.sh" do
    user "root"
    code <<-EOF
    /opt/oracle/app/product/11.2.0/dbhome_1/root.sh
    cat /opt/oracle/app/product/11.2.0/dbhome_1/install/root*.log
    EOF
  end

  template "/etc/oratab" do 
    cookbook "db_oracle"
    source "oratab.erb"
    mode "0744"
  end
end

action :setup_monitoring do
  db_state_get node

  ruby_block "evaluate db type" do
    block do
      if node[:db][:init_status].to_sym == :initialized
        node[:db_oracle][:collectd_master_slave_mode] = ( node[:db][:this_is_master] == true ? "Master" : "Slave" ) + "Stats true"
      else
        node[:db_oracle][:collectd_master_slave_mode] = ""
      end
    end
  end

  service "collectd" do
    action :nothing
  end

  platform = node[:platform]
  # Centos specific items
  collectd_version = node[:rightscale][:collectd_packages_version]
  package "collectd-oracle" do
    action :install
    version "#{collectd_version}" unless collectd_version == "latest"
    only_if { platform =~ /redhat|centos/ }
  end

  template ::File.join(node[:rightscale][:collectd_plugin_dir], 'oracle.conf') do
    source "collectd-plugin-oracle.conf.erb"
    mode "0644"
    backup false
    cookbook 'db_oracle'
    notifies :restart, resources(:service => "collectd")
  end

  # Send warning if not centos/redhat or ubuntu
  log "  WARNING: attempting to install collectd-oracle on unsupported platform #{platform}, continuing.." do
    not_if { platform =~ /centos|redhat|ubuntu/ }
    level :warn
  end

end

action :grant_replication_slave do
  Chef::Log.info ":grant_replication_slave is not implemented yet."
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
  Chef::Log.info ":promote is not implemented yet."

=begin
  db_state_get node

  x = node[:db_oracle][:log_bin]
  logbin_dir = x.gsub(/#{::File.basename(x)}$/, "")
  directory logbin_dir do
    action :create
    recursive true
    owner 'mysql'
    group 'mysql'
  end

  # Set read/write in my.cnf
  node[:db_oracle][:tunable][:read_only] = 0
  # Enable binary logging in my.cnf
  node[:db_oracle][:log_bin_enabled] = true

  # Setup my.cnf
  db_oracle_set_mycnf "setup_mycnf" do
    server_id RightScale::Database::MySQL::Helper.mycnf_uuid(node)
    relay_log RightScale::Database::MySQL::Helper.mycnf_relay_log(node)
  end

  db node[:db][:data_dir] do
    action :start
    persist false
    only_if do
      log_bin = RightScale::Database::MySQL::Helper.do_query(node, "show variables like 'log_bin'", 'localhost', RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT)
      if log_bin['Value'] == 'OFF'
        Chef::Log.info "  Detected binlogs were disabled, restarting service to enable them for Master takeover."
        true
      else
      	false
      end
    end
   
  end

  RightScale::Database::MySQL::Helper.do_query(node, "SET GLOBAL READ_ONLY=0", 'localhost', RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT)
  newmasterstatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW SLAVE STATUS', 'localhost', RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT)
  previous_master = node[:db][:current_master_ip]
  raise "FATAL: could not determine master host from slave status" if previous_master.nil?
  Chef::Log.info "  host: #{previous_master}}"

  # PHASE1: contains non-critical old master operations, if a timeout or
  # error occurs we continue promotion assuming the old master is dead.
  begin
    # OLDMASTER: query with terminate (STOP SLAVE)
    RightScale::Database::MySQL::Helper.do_query(node, 'STOP SLAVE', previous_master, RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT, 2)

    # OLDMASTER: flush_and_lock_db
    RightScale::Database::MySQL::Helper.do_query(node, 'FLUSH TABLES WITH READ LOCK', previous_master, 5, 12)


    # OLDMASTER:
    masterstatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW MASTER STATUS', previous_master, RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT)

    # OLDMASTER: unconfigure source of replication
    RightScale::Database::MySQL::Helper.do_query(node, "CHANGE MASTER TO MASTER_HOST=''", previous_master, RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT)

    master_file=masterstatus['File']
    master_position=masterstatus['Position']
    Chef::Log.info "  Retrieved master info...File: " + master_file + " position: " + master_position

    Chef::Log.info "  Waiting for slave to catch up with OLDMASTER (if alive).."
    # NEWMASTER localhost:
    RightScale::Database::MySQL::Helper.do_query(node, "SELECT MASTER_POS_WAIT('#{master_file}',#{master_position})")
  rescue => e
    Chef::Log.info "  WARNING: caught exception #{e} during non-critical operations on the OLD MASTER"
  end

  # PHASE2: reset and promote this slave to master
  # Critical operations on newmaster, if a failure occurs here we allow it to halt promote operations
  Chef::Log.info "  Promoting slave.."
  RightScale::Database::MySQL::Helper.do_query(node, 'RESET MASTER')

  newmasterstatus = RightScale::Database::MySQL::Helper.do_query(node, 'SHOW MASTER STATUS')
  newmaster_file=newmasterstatus['File']
  newmaster_position=newmasterstatus['Position']
  Chef::Log.info "  Retrieved new master info...File: " + newmaster_file + " position: " + newmaster_position

  Chef::Log.info "  Stopping slave and misconfiguring master"
  RightScale::Database::MySQL::Helper.do_query(node, "STOP SLAVE")
  RightScale::Database::MySQL::Helper.do_query(node, "RESET SLAVE")
  action_grant_replication_slave
  RightScale::Database::MySQL::Helper.do_query(node, 'SET GLOBAL READ_ONLY=0')

  # PHASE3: more non-critical operations, have already made assumption oldmaster is dead
  begin
    unless previous_master.nil?
      # Unlocking oldmaster
      RightScale::Database::MySQL::Helper.do_query(node, 'UNLOCK TABLES', previous_master)
      SystemTimer.timeout_after(RightScale::Database::MySQL::Helper::DEFAULT_CRITICAL_TIMEOUT) do
        # Demote oldmaster
        Chef::Log.info "  Calling reconfigure replication with host: #{previous_master} ip: #{node[:cloud][:private_ips][0]} file: #{newmaster_file} position: #{newmaster_position}"
        RightScale::Database::MySQL::Helper.reconfigure_replication(node, previous_master, node[:cloud][:private_ips][0], newmaster_file, newmaster_position)
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
  Chef::Log.info(":enable_replication is not implemented yet")
=begin
  db_state_get node
  current_restore_process = new_resource.restore_process

  # Check the volume before performing any actions.  If invalid raise error and exit.
  ruby_block "validate_master" do
    not_if { current_restore_process == :no_restore }
    block do
      master_info = RightScale::Database::MySQL::Helper.load_replication_info(node)

      # Check that the snapshot is from the current master or a slave associated with the current master
      if master_info['Master_instance_uuid']
        if master_info['Master_instance_uuid'] != node[:db][:current_master_uuid]
          raise "FATAL: snapshot was taken from a different master! snap_master was:#{master_info['Master_instance_uuid']} != current master: #{node[:db][:current_master_uuid]}"
        end
        # 11H1 backup
      elsif master_info['Master_instance_id']
        Chef::Log.info "  Detected 11H1 snapshot to migrate"
        if master_info['Master_instance_id'] != node[:db][:current_master_ec2_id]
          raise "FATAL: snapshot was taken from a different master! snap_master was:#{master_info['Master_instance_id']} != current master: #{node[:db][:current_master_ec2_id]}"
        end
        # File not found or does not contain info
      else
        raise "Position and file not saved!"
      end
    end
  end

  ruby_block "wipe_existing_runtime_config" do
    not_if { current_restore_process == :no_restore }
    block do
      Chef::Log.info "  Wiping existing runtime config files"
      data_dir = ::File.join(node[:db][:data_dir], 'mysql')
      files_to_delete = [ "master.info","relay-log.info","mysql-bin.*","*relay-bin.*"]
      files_to_delete.each do |file|
        expand = Dir.glob(::File.join(data_dir,file))
        unless expand.empty?
          expand.each do |exp_file|
            FileUtils.rm_rf(exp_file)
          end
        end
      end
    end
  end

  # Disable binary logging
  node[:db_oracle][:log_bin_enabled] = false

  # Setup my.cnf
  unless current_restore_process == :no_restore
    # Setup my.cnf
    db_oracle_set_mycnf "setup_mycnf" do
      server_id RightScale::Database::MySQL::Helper.mycnf_uuid(node)
      relay_log RightScale::Database::MySQL::Helper.mycnf_relay_log(node)
    end
  end

  # empty out the binary log dir
  directory ::File.dirname(node[:db_oracle][:log_bin]) do
    not_if { current_restore_process == :no_restore }
    action [:delete, :create]
    recursive true
    owner 'mysql'
    group 'mysql'
  end

  # ensure_db_started
  # service provider uses the status command to decide if it
  # has to run the start command again.
  10.times do
    db node[:db][:data_dir] do
      action :start
      persist false
    end
  end

  ruby_block "configure_replication" do
    not_if { current_restore_process == :no_restore }
    block do
      master_info = RightScale::Database::MySQL::Helper.load_replication_info(node)
      newmaster_host = master_info['Master_IP']
      newmaster_logfile = master_info['File']
      newmaster_position = master_info['Position']
      RightScale::Database::MySQL::Helper.reconfigure_replication(node, 'localhost', newmaster_host, newmaster_logfile, newmaster_position)
    end
  end

  # following done after a stop/start and reboot on a slave
  ruby_block "reconfigure_replication" do
    only_if { current_restore_process == :no_restore }
    block do
      master_info = RightScale::Database::MySQL::Helper.load_master_info_file(node)
      newmaster_host = node[:db][:current_master_ip]
      newmaster_logfile = master_info['File']
      newmaster_position = master_info['Position']
      RightScale::Database::MySQL::Helper.reconfigure_replication(node, 'localhost', newmaster_host, newmaster_logfile, newmaster_position)
    end
  end

  ruby_block "do_query" do
    not_if { current_restore_process == :no_restore }
    block do
      RightScale::Database::MySQL::Helper.do_query(node, "SET GLOBAL READ_ONLY=1")
    end
  end

  node[:db_oracle][:tunable][:read_only] = 1
=end
end

action :generate_dump_file do
  Chef::Log.info(":generate_dump_file is not implemented yet")
=begin
  db_name     = new_resource.db_name
  dumpfile    = new_resource.dumpfile

  execute "Write the mysql DB backup file" do
    command "mysqldump --single-transaction -u root #{db_name} | gzip -c > #{dumpfile}"
  end
=end
end

action :restore_from_dump_file do
  Chef::Log.info(":restore_from_dump_file is not implemented yet")
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

  bash "Import MySQL dump file: #{dumpfile}" do
    only_if { db_check.empty? }
    user "root"
    flags "-ex"
    code <<-EOH
      if [ ! -f #{dumpfile} ]
      then
        echo "ERROR: MySQL dumpfile not found! File: '#{dumpfile}'"
        exit 1
      fi
      mysqladmin -u root create #{db_name}
      gunzip < #{dumpfile} | mysql -u root -b #{db_name}
    EOH
  end
=end
end
