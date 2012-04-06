cookbook_file "/tmp/ruby-oci8-2.0.6.tar.gz" do 
  source "ruby-oci8-2.0.6.tar.gz"
  mode "0644"
end

cookbook_file "/tmp/oracle_tools.tar" do
  source "oracle_tools.tar"
  mode "0644"
end

directory "/opt/oracle/.ora_creds" do 
  owner "oracle"
  group "oracle"
  action :create
end

template "/opt/oracle/.ora_creds/ora_creds.rb" do 
  source "ora_creds.rb.erb"
  owner "oracle"
  group "oracle"
  mode "0600"
end
  
bash "install-local-ruby-oci8" do
  user "root"
  cwd "/tmp"
  code <<-EOF
    . /etc/profile.d/oracle_profile.sh
    tar -xvzf ruby-oci8-2.0.6.tar.gz
    cd ruby-oci8-2.0.6
    /usr/bin/ruby setup.rb config
    /usr/bin/ruby setup.rb setup
    /usr/bin/ruby setup.rb install
    tar -xf /tmp/oracle_tools.tar -C /usr/local/bin/
    chmod +x /usr/local/bin/*
    su - -c "/usr/bin/ruby /usr/local/bin/ruby-oci8-check.rb" oracle
    make clean
EOF
  not_if "test -e /usr/lib/ruby/site_ruby/1.8/oci8.rb"
end

bash "install-local-ruby-oci8" do
  user "root"
  cwd "/tmp"
  code <<-EOF
    . /etc/profile.d/oracle_profile.sh
    cd ruby-oci8-2.0.6
    /opt/rightscale/sandbox/bin/ruby setup.rb config
    /opt/rightscale/sandbox/bin/ruby setup.rb setup
    /opt/rightscale/sandbox/bin/ruby setup.rb install
  EOF
  not_if "test -e /opt/rightscale/sandbox/lib/ruby/site_ruby/1.8/oci8.rb"
end

