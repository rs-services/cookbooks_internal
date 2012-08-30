#
## Cookbook Name:: db_oracle
##
## Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
## RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
## if applicable, other agreements such as a RightScale Master Subscription Agreement.

require 'date'

#database backup settings
date = DateTime.now
backup_string="#{date.month}-#{date.day}-#{date.year}-#{date.hour}-#{date.min}-#{date.sec}"
default[:db_oracle][:backup][:dmpdir] = "/mnt/ephemeral/backup"
default[:db_oracle][:backup][:backup_prefix] = "expdp"
default[:db_oracle][:backup][:dmpfile] = "#{node[:db_oracle][:backup][:backup_prefix]}-#{backup_string}"
default[:db_oracle][:backup][:logfile] = "#{node[:db_oracle][:backup][:backup_prefix]}_full-#{backup_string}.log"

default[:db_oracle][:version]='11.2.0'