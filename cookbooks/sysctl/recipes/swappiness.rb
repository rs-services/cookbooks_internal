
sysctl "vm.swappiness" do
  action :set
  value node[:sysctl][:vm][:swappiness]
end
