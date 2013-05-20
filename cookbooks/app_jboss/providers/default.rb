#
# Cookbook Name:: app_jboss
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

# Installing required packages and configuration for JBoss.
action :install do
	include_recipe "app_jboss::install"	
end

# Start jboss service
action :start do
  log "  Running start sequence"
  service "jboss" do
    action :start
    persist false
  end
end

# Stop jboss service
action :stop do
  log "  Running stop sequence"
  service "jboss" do
    action :stop
    persist false
  end
end
