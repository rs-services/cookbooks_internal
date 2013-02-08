rightscale_marker :begin
#http://mirror.linux.org.au/linux.conf.au/2013/ogv/How_to_make_almost_anything_go_faster.ogv
%w{htop dstat kernel-devel perf strace iostat iotop iftop}.each do |pkg|
  package pkg do
    action :install
  end
end


rightscale_marker :end
