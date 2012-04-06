
package "compat-libstdc++-33" do
  action :install
end

package "glibc-devel" do
  action :install
end

package "libaio-devel" do
  action :install
end

package "sysstat" do 
  action :install
end

package "unixODBC-devel" do
  action :install
end

package "pdksh" do 
  action :install
end

package "elfutils-libelf-devel" do
  action :install
end

package "unixODBC" do
  action :install
end

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
  source "db.rsp.erb"
  mode "0755"
  variables(
    :starterdb_password_all => node[:oracle][:starterdb][:password][:all],
    :starterdb_password_sys => node[:oracle][:starterdb][:password][:sys],
    :starterdb_password_system => node[:oracle][:starterdb][:password][:system],
    :starterdb_password_sysman => node[:oracle][:starterdb][:password][:sysman],
    :starterdb_password_dbsnmp => node[:oracle][:starterdb][:password][:dbsnmp]
)
end

template "/etc/profile.d/oracle_profile.sh" do
  source "oracle_profile.sh.erb"
  mode "0777"
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
file_exists=0
while [ $file_exists == 0 ]; do 
  echo "file_exists = "$file_exists
  if [ -e /opt/oracle/inventory/logs/*.out ]; then 
    file_exists=1;
    log_file_name=`ls -1 /opt/oracle/inventory/logs/*.out`;
    echo $log_file_name;
  else
    sleep 30; 
    echo "File Does not Exist";
 fi 
done
successful_status=0
#while [ $successful_status != 516 ]; do
#  successful_status=`wc -c $log_file_name | cut -d ' ' -f 1`;
#  echo "waiting for oracle to complete, sleeping 30 - count is $successful_status"; 
#  sleep 30;
#done

EOF
end

bash "/opt/oracle/inventory/orainstRoot.sh" do
  user "root"
  code <<-EOF
  /opt/oracle/inventory/orainstRoot.sh
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
  source "oratab.erb"
  mode "0744"
end

