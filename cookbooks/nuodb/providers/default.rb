#
# Cookbook Name:: Nuodb
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


# Stop nuoagent
action :stop do
  log "Stopping nuoagent"
  service "nuoagent" do
    action :stop
  end 
end

# Start nuoagent
action :start do
  log "Starting nuoagent"
  service "nuoagent" do
    action :start
  end 
end

# Reloading nuoagent
action :restart do
  log "Reloading Nuodb"
  service "nuoagent" do
    action :restart
  end
end

# Set node as peer
action :set_peer do
  log "Setting myself as Peer with address as #{node[:nuodb][:nuodb_alt_addr]} and advertising it " 
  right_link_tag "nuodb:nuodb_peer=#{node[:nuodb][:nuodb_alt_addr]}"
  node[:nuodb][:nuodb_advertise_alt_addr]="true"
  node[:nuodb][:nuodb_broker_flag]="true"
  service "nuoagent" do
    action :restart
  end
end

# Start broker action
action :start_nuodb_broker do
  log "Setting node as broker and starting broker process"
  node[:nuodb][:nuodb_broker_flag]="true"
  service "nuoagent" do
    action :restart
  end
end

# Start nuodb  engine 
action :start_trans do
  log "Starting nuodb transaction engine"
  right_link_tag "nuodb:nuodb_type=trans"
  bash "Start transaction engine" do
    flags "-ex"
    code <<-EOH
java -jar /opt/nuodb/jar/nuodbmanager.jar --broker #{node[:nuodb_peers][0]} --password #{node[:nuodb][:nuodb_domain_password]}  --command "start process te host localhost database #{node[:nuodb][:nuodb_database]} options '--dba-user #{node[:nuodb][:nuodb_dba_user]} --dba-password #{node[:nuodb][:nuodb_dba_password]}'"
    EOH
  end
end

# Start nuodb storage engine
action :start_stor do
  log "Starting nuodb storage engine"
  right_link_tag "nuodb:nuodb_type=stor"
  bash "Start storage engine" do
    flags "-ex"
    code <<-EOH
java -jar /opt/nuodb/jar/nuodbmanager.jar --broker #{node[:nuodb_peers][0]} --password #{node[:nuodb][:nuodb_domain_password]}  --command "start process sm host localhost database #{node[:nuodb][:nuodb_database]} archive #{node[:nuodb][:noudb_archive_location]} initialize #{node[:nuodb][:nuodb_arch_int_flag]} options '--dba-user #{node[:nuodb][:nuodb_dba_user]} --dba-password #{node[:nuodb][:nuodb_dba_password]}'"
    EOH
  end 
end
