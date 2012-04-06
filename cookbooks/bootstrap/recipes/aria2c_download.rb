include_recipe "bootstrap::aria2c"

bash "download" do
  user "root"
  cwd node[:aria2c][:download_dir]
  code <<-EOF
  cd #{node[:aria2c][:download_dir]}
  aria2c #{node[:aria2c][:download_file]}
EOF
end
