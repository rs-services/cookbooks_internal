rightscale_marker :begin

bash "stop zookeeper" do
  flags "-ex"
  code <<-EOH
  #!/bin/bash
  cd #{node[:zookeeper][:zooDir]}
  nohup bin/zkServer.sh stop
  EOH
end

rightscale_marker :end