[ :stop, :start, :status ].each do |act|
  db node[:db][:data_dir] do
    user node[:db][:admin][:user]
    password node[:db][:admin][:password]
    action act
  end
end

