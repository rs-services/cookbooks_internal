rightscale_marker :begin

if !node[:nodejs][:npm][:settings].nil?
  node[:nodejs][:npm][:settings].each do |k,v|
    nodejs_npm_config "#{k}" do
      value "#{v}"
      action :set
    end
  end
end

rightscale_marker :end
