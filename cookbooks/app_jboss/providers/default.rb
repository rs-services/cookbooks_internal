#
# Cookbook Name:: app_jboss
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# Stop jboss service

#Installing required packages and prepare system for jboss
action :install do


  jboss_source = "jboss-as-7.1.1.Final.tar.gz"
  INSTALLTARGET = "/usr/local/jboss"

  # Creation of Jboss group and user
  group "jboss" do
  end

  user "jboss" do
    comment "Jboss User"
    gid "jboss"
    home "/usr/local/jboss"
    shell "/sbin/nologin"
  end

  directory "#{INSTALLTARGET}" do
    owner "jboss"
    group "jboss"
    mode "0755"
    action :create
  end

  # Extracting jboss from source
  bash "extract jboss from source" do
    flags "-ex"
    code <<-EOH
      cd /tmp
      wget -q http://rb.rsymphony.com/#{jboss_source}
      tar xzf #{jboss_source} -C #{INSTALLTARGET} --strip-components=1
      chown -R jboss:jboss #{INSTALLTARGET}
    EOH
  end

  cookbook_file "/etc/init.d/jboss" do
    source "jboss_init.sh"
    mode "0755"              
    cookbook 'app_jboss'
    only_if "test -d #{INSTALLTARGET}/standalone"
  end

  service "jboss" do
    supports :status => true, :restart => true, :start => true, :stop => true
    action :stop
  end

#  template "#{INSTALLTARGET}/standalone/configuration/standalone.xml" do
#    action :create
#    source "standalone.xml.erb"
#    owner jboss
#    group jboss
#    mode "0644"              
#  end
  # Moving jboss logs to ephemeral

  # Deleting old jboss log directory
  directory "/var/log/jboss" do
    recursive true
    action :delete
  end


  # Creating new directory for jboss logs on ephemeral volume
  directory "/mnt/ephemeral/log/jboss" do
    owner node[:app][:user]
    group node[:app][:group]
    mode "0755"
    action :create
    recursive true
  end

  # Create symlink from /var/log/jboss to ephemeral volume
  link "/var/log/jboss" do
    to "/mnt/ephemeral/log/jboss"
  end

  service "jboss" do
    action :start
  end

end
