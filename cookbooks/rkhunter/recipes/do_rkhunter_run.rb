rightscale_marker :begin

execute "rkhunter --update -q"

bash "rkhuner -c -sk --summary" do
  code <<-EOF
    rkhuner -c -sk --summary
  EOF
end

rightscale_marker :end
