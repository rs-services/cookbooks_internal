package "mlocate" do
  action :install
end
bash "updatedb" do
  user "root"
  code <<-EOF
  updatedb
  EOF
end 
