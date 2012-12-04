rightscale_marker :begin

private_ip = @node[:cloud][:private_ips][0]

bash "add tag" do
  flags "-ex"
  code <<-EOH
  #!/bin/bash
  `rs_tag --add 'zoonode:ip=#{private_ip}'`
  EOH
end


  

rightscale_marker :end