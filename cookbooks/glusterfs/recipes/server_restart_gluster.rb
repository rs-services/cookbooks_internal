marker "recipe_start"

service node["glusterfs"]["servicename"] do
  action [ :restart ]
  supports :status => true, :restart => true
  ignore_failure true
end

