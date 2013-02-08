maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures rightscale_services_tools"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "rightscale_services_tools::default", "enables rightscale_services_tools"
recipe "rightscale_services_tools::install_support_tools", "installs troubleshooting tools"
