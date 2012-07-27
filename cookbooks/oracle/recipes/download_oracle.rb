include_recipe"bootstrap::aria2c"

bash "download-disk-1" do
  user "root"
  cwd '/mnt/ephemeral'
  code <<-EOF
  aria2c #{node[:oracle][:install_file1_url]} -x 16 -d /mnt/ephemeral
EOF
end

bash "extract" do
  user "root"
  cwd '/mnt/ephemeral'
  code <<-EOF
  unzip -q `basename #{node[:oracle][:install_file1_url]}`
  rm -fr `basename #{node[:oracle][:install_file1_url]}`
EOF
end

bash "download-disk-2" do
  user "root"
  cwd '/mnt/ephemeral'
  code <<-EOF
  aria2c #{node[:oracle][:install_file2_url]} -x 16 -d /mnt/ephemeral
EOF
end

bash "extract" do
  user "root"
  cwd '/mnt/ephemeral'
  code <<-EOF
  unzip -q `basename #{node[:oracle][:install_file1_url]}`
  rm -fr `basename #{node[:oracle][:install_file1_url]}`
EOF
end
