rightscale_marker :begin

if !node[:nodejs][:npm][:packages].nil?
  node[:nodejs][:npm][:packages].each do |pkg|
    nodejs_npm "#{pkg}" do
      action :install
    end
  end
end

rightscale_marker :end
