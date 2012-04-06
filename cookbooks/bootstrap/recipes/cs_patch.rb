if node[:cloud][:provider] == "cloudstack"
group "rvm" do
  action :remove
end

bash "cs-patch-do" do
  user "root"
  cwd "/"
  code <<-EOF
rm -fr /etc/yum.repos.d/centos.repo
EOF
end

package "ruby" do
  action :install
end
end

