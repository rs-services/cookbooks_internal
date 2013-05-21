rightscale_marker :begin

package "glusterfs" do
	case node[:platform]
	when "centos", "redhat"
		package_name "glusterfs-fuse"
	when "ubuntu"
		package_name "

	action :install
end

rightscale_marker :end
