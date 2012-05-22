case node[:platform]
when "centos","fedora","suse","redhat"
  template "/var/www/html/index.html" do
    source "solr-redirect.html.erb"
    mode "0755"
    variables( :public_hostname => node[:cloud][:public_hostname] )
  end
end
