include_recipe "oracle::install_local_and_sandbox_oci8_rubygem_on_server"
bash "tune-memory" do
  user "root"
  cwd "/"
  code <<-EOF
su -c '/usr/local/bin/oracle_sga_tuning.sh' oracle
EOF
end

