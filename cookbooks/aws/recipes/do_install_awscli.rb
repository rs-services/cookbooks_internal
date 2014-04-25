rightscale_marker :begin

python_pip "awscli" do 
  action :install
end

directory "/root/.aws" do
  owner "root"
  group "root"
  mode "0600"
  action :create
end

template "/root/.aws/config" do
  source "aws_config.erb"
  owner "root"
  group "root"
  mode "0600"
  variables( :aws_access_key_id => node[:aws][:aws_access_key_id],
             :aws_secret_access_key => node[:aws][:aws_secret_access_key],
             :aws_region  => node[:aws][:region] )
  action :create
end

rightscale_marker :end
