rightscale_marker :begin

class Chef::Recipe
  include RightScale::App::Helper
end

pool_names(node[:lb][:pools]).each do |pool_name|
  log " Adding tag to answer for vhost load balancing - #{pool_name}."
  # See cookbooks/lb/definitions/lb_tag.rb for the "lb_tag" definition.
  lb_tag pool_name

  log " Sending remote attach request..."
  # See cookbooks/lb_<provider>/providers/default.rb for the "attach_request" action.
  node[:lb][:service][:provider]="lb_clb"
  log "LB Service Provider set to #{node[:lb][:service][:provider]}"
  lb pool_name do
    provider node[:lb][:service][:provider]
    backend_id node[:rightscale][:instance_uuid]
    backend_ip node[:app][:ip]
    backend_port node[:app][:port].to_i
    service_region node[:lb][:service][:region]
    service_lb_name node[:lb][:service][:lb_name]
    service_account_id node[:lb][:service][:account_id]
    service_account_secret node[:lb][:service][:account_secret]
    action :attach_request
  end
  
  node[:lb][:service][:provider]="lb_client"
  log "LB Service Provider set to #{node[:lb][:service][:provider]}"
  lb pool_name do
    provider node[:lb][:service][:provider]
    backend_id node[:rightscale][:instance_uuid]
    backend_ip node[:app][:ip]
    backend_port node[:app][:port].to_i
    service_region node[:lb][:service][:region]
    service_lb_name node[:lb][:service][:lb_name]
    service_account_id node[:lb][:service][:account_id]
    service_account_secret node[:lb][:service][:account_secret]
    action :attach_request
  end
end

rightscale_marker :end
