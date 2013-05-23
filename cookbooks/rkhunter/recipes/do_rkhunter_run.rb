rightscale_marker :begin

execute "rkhunter --update --nocolors && true "

bash "rkhunter -c -sk --summary --nocolors" do
  code <<-EOF
    rkhunter -c -sk --summary --nocolors && true
  EOF
end

rightscale_marker :end
