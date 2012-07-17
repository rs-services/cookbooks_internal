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

%w{elfutils-libelf-devel glibc-devel gcc gcc-c++ libaio glibc-devel libaio-devel libstdc++ libstdc++ libstdc++-devel libgcc libstdc++-devel unixODBC unixODBC-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

sysctl "net.ipv4.ip_local_port_range" do
  value "1024   65535"
  action :set
end

template "#{location}/client.rsp" do
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
/opt/oracle/app/oraInventory/orainstRoot.sh
EOF
end

template "/etc/profile.d/oracle_profile.sh" do
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
