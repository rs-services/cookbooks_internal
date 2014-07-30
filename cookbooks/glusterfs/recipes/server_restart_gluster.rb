rightscale_marker :begin

service "glusterd" do
  action [ :restart ]
  supports :status => true, :restart => true
  ignore_failure true
end

rightscale_marker :end
