maintainer       "RightScale"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures rs-sysctl"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "sysctl::default", "installs default sysctl values"
recipe "sysctl::swappiness", "sets vm.swappiness"

attribute "sysctl/vm/swappiness", 
  :display_name => "System VM Swappiness", 
  :description => "System VM Swappiness",
  :required => "optional",
  :default => "60",
  :recipes => [ "sysctl::swappiness" ]
