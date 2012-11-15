rightscale_marker :begin


log "Installing Zookeeper"

zooFile=node[:zookeeper][:zooFile]
zooDir=node[:zookeeper][:zooDir]


directory node[:zookeeper][:configuration][:dataDir] do
  recursive true
  action :create
end

directory node[:zookeeper][:configuration][:dataLogDir] do
  recursive true
  action :create
end

remote_file "/tmp/#{zooFile}" do
  source #{zooFile}
  owner "root"
  group "root"
  mode "0755"
  backup false
end

bash "untar zookeeper and install" do
  flags "-ex"
  code <<-EOH
  cd /tmp
  tar -zxvf #{zooFile} -C /opt/
  ln -s /opt/zookeeper-3.4.4 #{zooDir}
  EOH
end

template "#{zooDir}/conf/zoo.cfg" do
  source "zoo.erb"
  mode "644"
end


rightscale_marker :end
