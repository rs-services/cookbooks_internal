#
#http://oraclehack.blogspot.com/2011/02/scheduler-and-data-pump-expdb.html
#http://www.oracle-dba-online.com/data_pump_utility.htm
#install requirements

gem_package "s3cmd" do
  action :install
end

gem_package "chronic" do
  action :install
end

directory node[:oracle][:backup][:dmpdir] do
  owner "oracle"
  group "oracle"
  mode "0755"
  action :create
end

template "/opt/oracle/database_backup_setup.sh" do
  source "database_backup_setup.sh.erb"
  owner "oracle"
  mode "0755"
end

bash "create-oracle-backup-dir" do
  cwd "/opt/oracle"
  user "oracle"
  flags "-e"
  code <<-'EOF'
. /etc/profile.d/oracle_profile.sh 
su - -c "/opt/oracle/database_backup_setup.sh" oracle
EOF
end

template "/opt/oracle/backup_settings.par" do 
  owner "oracle"
  group "oracle"
  mode "0644"
  source "backup_settings.par.erb"
  variables(:backup_user => "/ as sysdba",
  :schemas => "#{node[:oracle][:backup][:restore_schemas]}"
  )
end

bash "backup-oracle-db" do 
  cwd "/opt/oracle"
  user "oracle"
  flags "-ex"
  code <<-EOF
  cd #{node[:oracle][:backup][:dmpdir]}
  . /etc/profile.d/oracle_profile.sh
  su - -c "expdp parfile=/opt/oracle/backup_settings.par" oracle
    dumpfile=`grep ^DUMPFILE /opt/oracle/backup_settings.par | awk '{split($0,a,"="); print a[2]}'`
    logfile=`grep LOGFILE /opt/oracle/backup_settings.par | awk '{split($0,a,"="); print a[2]}'`
    gzip $dumpfile
    export AWS_ACCESS_KEY_ID=#{node[:amazon][:access_key_id]}
    export AWS_SECRET_ACCESS_KEY=#{node[:amazon][:secret_access_key]}
    export AWS_CALLING_FORMAT=SUBDOMAIN
    s3cmd put #{node[:oracle][:backup][:bucket]}:$dumpfile.gz $dumpfile.gz
    s3cmd put #{node[:oracle][:backup][:bucket]}:logs/$logfile $logfile
    rm -f $dumpfile
    rm -f $dumpfile.gz
    rm -f $logfile
EOF
end
