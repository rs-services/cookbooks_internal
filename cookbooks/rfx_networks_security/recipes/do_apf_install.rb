rightscale_marker :begin

remote_file "/tmp/apf-current.tar.gz" do
  owner "root"
  group "root"
  source "http://www.rfxn.com/downloads/apf-current.tar.gz"
  mode "0644"
  action :create
end

bash "untar and install" do
  code <--EOF
    tar -xzf apf-current.tar.gz
    cd apf*
    ./install.sh
  EOF
end

