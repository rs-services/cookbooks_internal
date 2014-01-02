maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
license          'All rights reserved'
description      'Installs limits.conf'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
recipe "limits::default", "Installs limits.conf"

attribute "limits/priority",
  :description => "Priority value to set postgres user pids to (can be negative).",
  :recipes     => ["limits::default"],
  :type        => "string",
  :display     => "limits/priority",
  :required    => "required"
