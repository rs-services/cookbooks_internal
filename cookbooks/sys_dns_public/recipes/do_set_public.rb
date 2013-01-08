rightscale_marker :begin

# This will set the DNS record identified by the “DNS Record ID” input to the first private IP address of the instance.
sys_dns "default" do
  id node[:sys_dns][:id]
  address node[:cloud][:public_ips][0]
  region node[:sys_dns][:region]
  action :set_private
end

rightscale_marker :end
