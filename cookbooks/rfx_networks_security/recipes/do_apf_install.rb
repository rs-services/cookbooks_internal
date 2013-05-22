rightscale_marker :begin

remote_file "/tmp/apf-current.tar.gz" do
  owner "root"
  group "root"
  source "http://www.rfxn.com/downloads/apf-current.tar.gz"
  mode "0644"
  action :create
end

bash "untar and install" do
  cwd "/tmp"
  code <--EOF
    tar -xzf apf-current.tar.gz
    cd apf*
    ./install.sh
  EOF
end

template "/etc/apf/conf.apf" do
  source "conf.apf.erb"
  owner "root"
  group "root"
  mode "0640"
#  variables()
  action :create
end

service "apf" do
  actions [ :enable, :start ]
end

rightscale_marker :end
