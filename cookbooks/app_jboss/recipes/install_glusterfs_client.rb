rightscale_marker :begin

package "glusterfs" do
	case node[:platform]
	when "centos", "redhat"
		package_name "glusterfs-fuse"
	end
	action :install
end

rightscale_marker :end
