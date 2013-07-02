rightscale_marker :begin

require 'date'

template "/tmp/healthcheck.xml" do
  source "aws_healthcheck.xml.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :api_version => '2012-12-12',
    :hostname => node[:sys_dns][:id].split(':').last,
    :ip_address => node[:cloud][:public_ips][0],
    :date => DateTime.now.to_s
  )
  action :create
end

template "/root/.aws-secrets" do
  source "aws-secrets.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :id => node[:sys_dns][:user],
    :key => node[:sys_dns][:password]
  )
  action :create
end

bash "add health-check" do 
  code <<-EOF
    /opt/rightscale/dns/dnscurl.pl --keyfile /root/.aws-secrets --keyname my-aws-account -- -X POST -H "Content-Type: text/xml; charset=UTF-8" --upload-file /tmp/healthcheck.xml https://route53.amazonaws.com/2012-12-12/healthcheck 2>/dev/null | xmlstarlet fo - | awk -F '>' '/Id/{gsub(/<\/Id/,""); print $2 }' > /tmp/health_check_uuid

  rs_tag -a "lb:health_check_uuid=`cat /tmp/health_check_uuid`"
EOF
end

file "/root/.aws-secrets" do
  action :delete
  backup 0
end

rightscale_marker :end
