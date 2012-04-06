#
#http://oraclehack.blogspot.com/2011/02/scheduler-and-data-pump-expdb.html
#http://www.oracle-dba-online.com/data_pump_utility.htm

gem_package "chronic" do 
  action :install
end

bash "s3cmd-install" do
  user "root"
  code <<-EOF
  gem install s3sync
EOF
end

gem_package "s3cmd" do
  action :install
  not_if "test -e /usr/bin/gem"
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
  code <<-EOF
  . /etc/profile.d/oracle_profile.sh
  su - -c "/opt/oracle/database_backup_setup.sh" oracle
EOF
end

template "/opt/oracle/restore_settings.par" do 
  owner "oracle"
  group "oracle"
  mode "0644"
  source "restore_settings.par.erb"
  variables(:backup_user => "sys/#{node[:oracle][:starterdb][:password][:sys]} as sysdba",
            :schemas => "#{node[:oracle][:backup][:restore_schemas]}"
  )
end

bash "s3mcd-get-oracle-db" do 
  cwd "/opt/oracle"
  user "oracle"
  flags "-e"
  code <<-EOF
  cd #{node[:oracle][:backup][:dmpdir]}
  . /etc/profile.d/oracle_profile.sh
  export AWS_ACCESS_KEY_ID=#{node[:amazon][:access_key_id]}
  export AWS_SECRET_ACCESS_KEY=#{node[:amazon][:secret_access_key]}
  export AWS_CALLING_FORMAT=SUBDOMAIN
  backup_file=`s3cmd list #{node[:oracle][:backup][:bucket]}:#{node[:oracle][:backup][:backup_prefix]} 10000 | sort | tail -1`
  s3cmd get #{node[:oracle][:backup][:bucket]}:$backup_file $backup_file
  gunzip -f $backup_file
  sed -i -e "s/`grep DUMPFILE /opt/oracle/restore_settings.par`/DUMPFILE=${backup_file%.*}/" /opt/oracle/restore_settings.par
  su - -c "impdp parfile=/opt/oracle/restore_settings.par" oracle
EOF
end
