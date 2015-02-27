marker "recipe_start"

service "glusterd" do
  action [ :restart ]
  supports :status => true, :restart => true
  ignore_failure true
end

