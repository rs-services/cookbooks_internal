user "games" do
  action :remove
end

group "users" do
  gid 100
  action :remove
end

group "rvm" do
  gid 500
  action :remove
end

group "dba" do
  gid 100
end

group "users" do
  gid 500
end

group "gse" do
  gid 601 
end

group "gdev" do
  gid 602 
end
