template "/usr/local/bin/add_audit_user.rb" do
  source "add_audit_user.rb.erb"
  owner "oracle"
  group "oracle"
  mode "0755"
end

bash "add-audit-user" do 
  user "root"
  code <<-EOF
  su - -c "ruby /usr/local/bin/add_audit_user.rb" oracle
EOF
end
