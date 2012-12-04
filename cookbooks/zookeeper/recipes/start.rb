rightscale_marker :begin

bash "start zookeeper" do
  flags "-ex"
  code <<-EOH
  #!/bin/bash
  cd #{node[:zookeeper][:zooDir]}
  nohup bin/zkServer.sh start
  EOH
end

rightscale_marker :end