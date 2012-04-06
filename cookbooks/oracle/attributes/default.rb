require 'date'

#random password code from http://snippets.dzone.com/posts/show/2137
def random_password(size = 8)
  chars = (('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a) - %w(i o 0 1 l 0)
  (1..size).collect{|a| chars[rand(chars.size)] }.join
end
#sets db passwords
default[:oracle][:starterdb][:password][:all] = random_password(15)
default[:oracle][:starterdb][:password][:sys] = random_password(15)
default[:oracle][:starterdb][:password][:system] = random_password(15)
default[:oracle][:starterdb][:password][:sysman] = random_password(15)
default[:oracle][:starterdb][:password][:dbsnmp] = random_password(15)

#database backup settings
date = DateTime.now
backup_string="#{date.month}-#{date.day}-#{date.year}-#{date.hour}-#{date.min}-#{date.sec}"
default[:oracle][:backup][:dmpdir] = "/mnt/ephemeral/backup"
default[:oracle][:backup][:backup_prefix] = "expdp"
default[:oracle][:backup][:dmpfile] = "#{node[:oracle][:backup][:backup_prefix]}-#{backup_string}"
default[:oracle][:backup][:logfile] = "#{node[:oracle][:backup][:backup_prefix]}_full-#{backup_string}.log"

