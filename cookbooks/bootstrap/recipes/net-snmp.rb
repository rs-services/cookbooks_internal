
package "net-snmp" do
  action :install
end

template "/etc/snmp/snmpd.conf" do 
  source "snmpd.conf.erb"
  mode "0644"
end

service "snmpd" do 
  action :start
end

service "snmptrapd" do
  action :start
end
