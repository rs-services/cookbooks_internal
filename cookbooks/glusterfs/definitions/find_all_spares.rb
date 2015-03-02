# find all servers marked as 'spare'
define :find_all_spares, :tags=>[], :secondary_tags=>[] do
  class Chef::Resource::RubyBlock
    include Chef::MachineTagHelper
  end
  ips =[]
  r=ruby_block "find all spares" do
    block do
      tags = tag_search(node, ["#{params[:tags]}","#{params[:secondary_tags]}"])
      tags.each do |tag|
        tag["server:private_ip_0"].each do |t|
          ips << t.value
        end
      end
    end
  end
  r.run_action(:create)
  node.override[:glusterfs][:server][:spares] = ips

  # sanity check
  if  node[:glusterfs][:server][:spares].empty?
    raise "!!!> Didn't find any servers tagged with #{params[:tags]} " +
      "and #{params[:secondary_tags]}"
  end

end #define :find_spares
