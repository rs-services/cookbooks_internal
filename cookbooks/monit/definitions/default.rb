define :monit_process, :enable=>false, :process_name, :pidfile, :start_cmd, :stop_cmd do

  if params[:enable]
    template "/etc/monit/conf.d/#{params[:process_name]}.conf" do
      cookbook 'monit'
      source "service.conf.erb"
      owner "root"
      group "root"
      mode "0755"
      variables(
        :process_name => params[:process_name],
        :pidfile => params[:pidfile],
        :start_cmd => params[:start_cmd], 
        :stop_cmd => params[:stop_cmd]
      )
      action :create
      not_if "test -e /etc/monit/conf.d/#{params[:process_name]}.conf"
      notifies :restart, "service[monit]"
    end
  else
    file "/etc/monit/conf.d/#{params[:process_name]}.conf" do
      backup 0
      action :delete
      only_if "test -e /etc/monit/conf.d/#{params[:process_name]}.conf"
      notifies :restart, "service[monit]"
    end
  end

  service "monit"
end
