
package "openssl-devel" do 
  action :install
end

remote_file "/tmp/aria2-1.14.1-1.x86_64.rpm" do
  source "http://application-binaries.s3.amazonaws.com/aria2-1.14.1-1.x86_64.rpm"
  mode "0644"
end

bash "install-aria2" do
  user "root"
  cwd "/tmp/"
  code <<-EOF
  rpm -U aria2-1.14.1-1.x86_64.rpm
  EOF
end
