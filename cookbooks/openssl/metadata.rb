maintainer       "RightScale Inc"
maintainer_email "support@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures openssl"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe	"openssl::fix_ssl_root_ca", "updates root ca on centos/redhat"
