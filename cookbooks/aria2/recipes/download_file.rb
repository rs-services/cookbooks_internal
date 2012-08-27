bash "download" do
   user "root"
   cwd node[:aria2][:download_dir]
   code <<-EOF
    cd #{node[:aria2][:download_dir]}
    aria2c #{node[:aria2][:download_file]}
  EOF
end
