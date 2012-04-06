#https://gist.github.com/309568
define :sysctl_bak, :value => nil, :action => :set do
  execute "/sbin/sysctl -p" do
    action :nothing
  end

  t = begin
    resources(:template => "/etc/sysctl.conf")
  rescue
    template "/etc/sysctl.conf" do
      owner "root"
      group "root"
      source "sysctl.conf.erb"
      cookbook "sysctl"
      variables( :settings => {} )
      notifies :run, resources(:execute => "/sbin/sysctl -p")
    end
  end

  case params[:action]
  when :set
    log "setting #{params[:name]} = #{params[:value]}"
    t.variables[:settings].merge!({ params[:name] => params[:value] })
  when :unset
    t.variables[:settings].delete(params[:name])
  end
end

define :sysctl, :value => nil, :action => :set do

  directory "/etc/sysctl.d" do
    owner "root"
    group "root"
    mode "0755"
    action :create
    not_if "test -e /etc/sysctl.d"
  end

  cookbook_file "/usr/bin/sysctl-reload.sh" do 
    source "sysctl-reload.sh"
    owner "root"
    group "root"
    mode "0755"
    action :create_if_missing
  end

  execute "/usr/bin/sysctl-reload.sh" do
    action :nothing
  end

  case params[:action]
  when :set
    log "setting #{params[:name]} = #{params[:value]}"
    template "/etc/sysctl.d/#{params[:name]}" do
      source "sysctl.d.erb"
      backup false
      cookbook "sysctl"
      variables(
        :sysctl_key => params[:name],
        :sysctl_value => params[:value]
      )
      notifies :run, resources(:execute => "/usr/bin/sysctl-reload.sh")
    end
  when :unset
    file "/etc/sysctl.d/#{params[:name]}" do
      action :delete
      notifies :run, resources(:execute => "/usr/bin/sysctl-reload.sh")
    end
  end
end

define :sysctl_populate do
  node[:sysctl2] = Mash.new
  `sysctl -A`.each do |line|
     k,v = line.split(/=/).map {|i| i.strip!}
     node[:sysctl][k] = v
  end
end
