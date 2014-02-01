#
# Cookbook Name:: cassandra
# Recipe:: configure
#
# Copyright 2013, RightScale
#
# All rights reserved - Do Not Redistribute
#

rightscale_marker :begin

seed_ips   = Array.new
dirs       = Array.new
rack       = nil
datacenter = nil

# Find datacenter and rack that this host belongs to
if node[:cloud][:provider] == "ec2"
  datacenter = "ec2-#{node[:ec2][:placement][:availability_zone].chop}"
  rack       = "#{node[:ec2][:placement][:availability_zone]}"
elsif node[:cloud][:provider] == "google"
  datacenter = "google-#{node[:google][:zone].split('/').last.chop.chop}"
  rack       =  "#{node[:google][:zone].split('/').last}"
end

# Collect directories to create
dirs.push(node[:cassandra][:commitlog_directory])
dirs.push(node[:cassandra][:saved_caches_directory])
dirs += node[:cassandra][:data_file_directories]

# Find hosts that are going to be Cassandra seeds
seed_hosts = rightscale_server_collection "seed_hosts" do
  tags ["cassandra:seed_host=true"]

  # Use internal IP's if using Ec2Snitch, otherwise use public.
  if node[:cassandra][:snitch] == "Ec2Snitch"
    mandatory_tags ["server:private_ip_0"]
  else
    mandatory_tags ["server:public_ip_0"]
  end

  empty_ok false
  action :nothing
end
seed_hosts.run_action(:load)

if node["server_collection"]["seed_hosts"]
  Chef::Log.info "Server collection found ..."
  node["server_collection"]["seed_hosts"].to_hash.values.each do |tag|

    # Use internal IP's if using Ec2Snitch, otherwise use public.
    if node[:cassandra][:snitch] == "Ec2Snitch"
      seed_ips.push(RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tag))
    else
      seed_ips.push(RightScale::Utils::Helper.get_tag_value("server:public_ip_0", tag))
    end

  end
end

# Create Cassandra directories
dirs.each do |dir|
  directory "#{dir}" do
    owner "cassandra"
    group "cassandra"
    mode "0755"
    recursive true
    action :create
  end
end

# Install main Cassandra config file
template "/etc/cassandra/conf/cassandra.yaml" do
  source "#{node[:cassandra][:require_inter_node_encryption]}-cassandra.yaml.erb"
  owner "cassandra"
  group "cassandra"
  mode "0644"
 
  # Use the internal IP for everything if using Ec2Snitch
  if node[:cassandra][:snitch] == "Ec2Snitch"
    node[:cloud][:public_ips][0] = node[:cloud][:private_ips][0]
  end

  variables({
    :cluster_name           => node[:cassandra][:cluster_name],
    :snitch                 => node[:cassandra][:snitch],
    :commitlog_directory    => node[:cassandra][:commitlog_directory],
    :data_file_directories  => node[:cassandra][:data_file_directories],
    :saved_caches_directory => node[:cassandra][:saved_caches_directory],
    :encryption_password    => node[:cassandra][:encryption_password],
    :authorizer             => node[:cassandra][:authorizer],
    :authenticator          => node[:cassandra][:authenticator],
    :listen_address         => node[:cloud][:private_ips][0],
    :broadcast_address      => node[:cloud][:public_ips][0],
    :seeds                  => seed_ips
  })
end

# Only install rackdc.properties if using GossipingPropertyFileSnitch
if node[:cassandra][:snitch] == "GossipingPropertyFileSnitch"
  template "/etc/cassandra/conf/cassandra-rackdc.properties" do
    source "cassandra-rackdc.properties.erb"
    owner "cassandra"
    group "cassandra"
    mode "0644"
    variables({
      :datacenter => datacenter,
      :rack       => rack
    })
  end
end

# Install Cassandra truststore / keystore certs if needed
if node[:cassandra][:require_inter_node_encryption] == "true"
  bash "download_keystore" do
    code <<-EOM
      export STORAGE_ACCOUNT_ID="#{node[:cassandra][:storage_account_id]}"
      export STORAGE_ACCOUNT_SECRET="#{node[:cassandra][:storage_account_secret]}"
      /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:cassandra][:bucket]}" -s "#{node[:cassandra][:keystore]}" \
        -C "#{node[:cassandra][:provider]}" -d "/etc/cassandra/conf/keystore"
      chmod 0440 /etc/cassandra/conf/keystore
      chown cassandra:cassandra /etc/cassandra/conf/keystore
    EOM
  end

  bash "download_truststore" do
    code <<-EOM
      export STORAGE_ACCOUNT_ID="#{node[:cassandra][:storage_account_id]}"
      export STORAGE_ACCOUNT_SECRET="#{node[:cassandra][:storage_account_secret]}"
      /opt/rightscale/sandbox/bin/ros_util get -c "#{node[:cassandra][:bucket]}" -s "#{node[:cassandra][:truststore]}" \
        -C "#{node[:cassandra][:provider]}" -d "/etc/cassandra/conf/truststore"
      chmod 0440 /etc/cassandra/conf/truststore
      chown cassandra:cassandra /etc/cassandra/conf/truststore
    EOM
  end
end

service "cassandra" do
  action :enable
end

# Starting Cassandra via service above silently fails for some reason. Start it via the cli instead.
bash "start_cassandra" do
  flags "-ex"
  code <<-EOM
    service cassandra start
  EOM
end

rightscale_marker :end
