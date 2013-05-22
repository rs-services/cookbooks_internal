name             'rkhunter'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rkhunter'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"

recipe "rkhunter::default", "installs and configures rkhunter"
recipe "rkhunter::do_rkhunter_run", "updates and runs rkhunter"

attribute "rkhunter/admin_email", 
  :display_name => "Admin Email",
  :description => "Email to send reports to",
  :required => "required"
