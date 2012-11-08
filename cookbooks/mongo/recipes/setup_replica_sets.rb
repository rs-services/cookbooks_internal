
rightscale_marker :begin
  require 'mongo'
  results = rightscale_server_collection "mongo_replicas" do
    tags ["mongo:replSet=#{node[:mongo][:replSet]}"]
    secondary_tags ["server:private_ip_0=*"]
    empty_ok false
    action :nothing
  end

  results.run_action(:load)
  str_json="{ _id: '#{node[:mongo][:replSet]}', members: ["
  i=0
  if node["server_collection"]["mongo_replicas"]
    log "Server Collection Found"
    node["server_collection"]["mongo_replicas"].to_hash.values.each do |tags|
      master_ip=RightScale::Utils::Helper.get_tag_value("server:private_ip_0", tags)
      str_json+="{_id: #{i}, host: '#{master_ip}'},"
      i+=1
    end
  end
  str_json+=" ] }"
  connection = Mongo::Connection.new("localhost", 27017)
  db=connection.db("local")
  log str_json
  #db.command({ replSetInitiates : str_json })
  `mongo --eval "printjson(rs.initiate(#{str_json}))"`

rightscale_marker :end
