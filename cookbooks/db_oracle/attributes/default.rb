#
## Cookbook Name:: db_oracle
##
## Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
## RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
## if applicable, other agreements such as a RightScale Master Subscription Agreement.

require 'date'

#random password code from http://snippets.dzone.com/posts/show/2137
def random_password(size = 8)
  chars = (('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a) - %w(i o 0 1 l 0)
  (1..size).collect{|a| chars[rand(chars.size)] }.join
end
#sets db passwords
default[:db_oracle][:starterdb][:password][:all] = random_password(15)
default[:db_oracle][:starterdb][:password][:sys] = random_password(15)
default[:db_oracle][:starterdb][:password][:system] = random_password(15)
default[:db_oracle][:starterdb][:password][:sysman] = random_password(15)
default[:db_oracle][:starterdb][:password][:dbsnmp] = random_password(15)

#database backup settings
date = DateTime.now
backup_string="#{date.month}-#{date.day}-#{date.year}-#{date.hour}-#{date.min}-#{date.sec}"
default[:db_oracle][:backup][:dmpdir] = "/mnt/ephemeral/backup"
default[:db_oracle][:backup][:backup_prefix] = "expdp"
default[:db_oracle][:backup][:dmpfile] = "#{node[:db_oracle][:backup][:backup_prefix]}-#{backup_string}"
default[:db_oracle][:backup][:logfile] = "#{node[:db_oracle][:backup][:backup_prefix]}_full-#{backup_string}.log"

default[:db_oracle][:version]='11.2.0'