rightscale_marker :begin

hostname=node[:sys][:hostname].delete('#').delete('.').delete('(').delete(')').gsub(/ - /,'-').gsub(/ /,'-').downcase
bash "set-hostname" do
  code <<-EOF
    hostname #{hostname}
    sysctl -w kernel.hostname=#{hostname}
  EOF
end


rightscale_marker :end
