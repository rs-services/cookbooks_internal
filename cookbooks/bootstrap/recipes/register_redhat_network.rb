bash "register-system-with-redhat" do
  user "root"
  cwd "/root"
  code <<-EOF
for i in `grep enabled=1 /etc/yum.repos.d/redhat* | cut -d : -f 1`; do 
  sed -i -e 's/enabled=1/enabled=0/' $i; 
done
/usr/sbin/rhnreg_ks --profilename "#{node[:rightscale][:server_nickname]}" --username "#{node[:rhn][:username]}" --password "#{node[:rhn][:password]}" --nohardware --nopackages --novirtinfo --force
yum clean all
EOF

end
