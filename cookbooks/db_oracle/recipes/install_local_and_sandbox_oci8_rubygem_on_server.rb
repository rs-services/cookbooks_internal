#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

location = "/tmp"

bash "downloading ruby-oci8-2.0.6.tar.gz" do
  user "root"
  cwd location
  flags "-ex"
  code <<-EOF
  aria2c http://ps-cf.rightscale.com/oracle/ruby-oci8-2.0.6.tar.gz -x 16 -d #{location}
  EOF
end
bash "downloading oracle_tools.tar" do
  user "root"
  cwd location
  flags "-ex"
  code <<-EOF
  aria2c http://ps-cf.rightscale.com/oracle/oracle_tools.tar -x 16 -d #{location}
  EOF
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
rightscale_marker :end
