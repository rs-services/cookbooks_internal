#
# Cookbook Name:: rs-sysctl
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#rs_utils_marker :begin

sysctl_populate

log "  adding default kernel params"
node[:sysctl][:settings].each do |ctl_name, ctl_value|
  sysctl ctl_name do
    value ctl_value
    action :set
  end
end

#rs_utils_marker :end
