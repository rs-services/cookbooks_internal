#
# Cookbook Name:: jdk
# Recipe:: default
#
# Copyright 2012, RightScale, Inc.


# Not trying to make a generic Oracle Java cookbook that works across different
# distros and is flexible with versioning.
#
# This is just for the Samsung/SDS engagement and installs the JDK we need.

rs_utils_marker :begin

bash "download jdk" do
  cwd "/root"
  code <<-EOF
    aria2c #{node[:jdk][:url]} && touch /root/java/.keep
  EOF
  not_if "test -e /root/java/.keep"
end

bash "install jdk" do
  cwd "/opt"
  code <<-EOF
    bin=`ls -1 /root/java/*.bin | tail -1`
    /bin/sh $bin -noregister

    dir=`ls -1d jdk* | tail -1`
    rm -fv /opt/java
    ln -sfv /opt/$dir /opt/java

    touch /opt/java/.keep
  EOF
  not_if "test -e /opt/java/.keep"
end

cookbook_file "/etc/profile.d/java.sh" do
  source "java.sh"
end

rs_utils_marker :end
