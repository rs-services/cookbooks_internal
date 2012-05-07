define :gen_profile_script, :cookbook_name do 
  template "/etc/profile.d/#{params[:cookbook_name]}.sh" do
    cookbook "rightscale_services_tools"
    source "profile.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
      :cookbook_name => params[:cookbook_name].upcase,
      :install_dir => node["#{params[:cookbook_name]}"][:install_dir],
      :conf_dir => node["#{params[:cookbook_name]}"][:conf_dir],
      :lib_dir => node["#{params[:cookbook_name]}"][:lib_dir],
      :data_dir => node["#{params[:cookbook_name]}"][:data_dir]
    )
    action :create
  end
end
