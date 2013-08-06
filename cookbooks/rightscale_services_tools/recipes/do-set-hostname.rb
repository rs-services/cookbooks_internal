rightscale_marker :begin

hostname=node[:sys][:hostname].delete!('#').gsub(/ /,'-')
bash "set-hostname" do
  code <<-EOF
    hostname #{hostname}
    sysctl -w kernel.hostname=#{hostname}
  EOF
end


rightscale_marker :end
