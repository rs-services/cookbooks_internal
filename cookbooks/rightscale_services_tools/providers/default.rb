action :start_nat_monitor do
  bash "start nat_monitor.sh" do
    user "root"
    cwd "/root"
    code <<-EOH
  pkill nat-monitor > /dev/null
  /root/nat-monitor.sh >> /var/log/nat-monitor.log 2>&1 &
    EOH
  end

end

action :stop_nat_monitor do
  bash "stop nat-monitor.sh" do
    user "root"
    cwd "/root"
    code <<-EOH
  pkill nat-monitor > /dev/null
    EOH
  end
end