rightscale_marker :begin

remote_file "/tmp/bfd.tar.gz" do
  source "http://www.rfxn.com/downloads/bfd-current.tar.gz"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

bash "unzip and install" do
  cwd "/tmp"
  code <<-EOF
    tar -xzf bfd.tar.gz
    cd bfd*
    ./install.sh
  EOF
end

template "/usr/local/bfd/conf.bfd" do
  source "conf.bfd.erb"
  owner "root"
  group "root"
  mode "0644"
  variables( :trig => node[:rfx_networks_security][:bfd][:trigger] )  
  action :create
end
