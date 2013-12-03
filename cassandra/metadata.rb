name             'cassandra'
maintainer       'RightScale Professional Services'
maintainer_email 'ps@rightscale.com'
license          'All rights reserved'
description      'Installs/Configures cassandra'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.1'

depends "rightscale"

recipe "cassandra::install"
