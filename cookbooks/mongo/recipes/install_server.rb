remote_file "/tmp/mongodb.tar.gz" do
  source node[:mongo][:source]
  owner "root"
  group "root"
  mode "0644"
  action :create
end

user node[:mongo][:user] do
  action :create
end
