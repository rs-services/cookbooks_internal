name             'lb_multi'
maintainer       'RightScale Inc'
maintainer_email 'premium@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures lb_multi'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "rightscale"
depends "lb"
depends "lb_clb"
depends "lb_haproxy"

recipe "lb_multi::lb_connect", "connects to clb and haproxy"
recipe "lb_multi::lb_disconnect", "disconnects to clb and haproxy"
recipe "lb_multi::lb_connect_multi_clb", "connects to multiple clbs & haproxy"
recipe "lb_multi::lb_disconnect_multi_clb", "disconnects to multiple clbs & haproxy"

attribute "lb/pools",
  :display_name => "Load Balance Pools",
  :description =>
    "Comma-separated list of URIs or FQDNs for which the load balancer" +
    " will create server pools to answer website requests. The order of the" +
    " items in the list will be preserved when answering to requests." +
    " Last entry will be the default backend and will answer for all URIs and" +
    " FQDNs not listed here. A single entry of any name, e.g. 'default', " +
    " 'www.mysite.com' or '/appserver', will mimic basic behavior of" +
    " one load balancer with one pool of application servers. This will be" +
    " used for naming server pool backends. Application servers can provide" +
    " any numbers of URIs or FQDNs to join corresponding server pool" +
    " backends.Example: www.mysite.com, api.mysite.com, /serverid, default",
  :required => "recommended",
  :default => "default"

attribute "lb/session_stickiness",
  :display_name => "Use Session Stickiness",
  :description =>
    "Determines session stickiness. Set to 'True' to use session stickiness," +
    " where the load balancer will reconnect a session to the last server it" +
    " was connected to (via a cookie). Set to 'False' if you do not want to" +
    " use sticky sessions; the load balancer will establish a connection" +
    " with the next available server. Example: true",
  :required => "optional",
  :choice => ["true", "false"],
  :default => "true"
  

attribute "lb/service/provider",
  :display_name => "Load Balance Provider",
  :description =>
    "Specify the load balance provider to use either: 'lb_client' for" +
    " ServerTemplate based Load Balancer solutions (such as aiCache, HAProxy," +
    " etc.), 'lb_elb' for AWS Load Balancing, or 'lb_clb' for Rackspace Cloud" +
    " Load Balancing. Example: lb_client",
  :required => "recommended",
  :default => "lb_client",
  :choice => ["lb_client", "lb_clb", "lb_elb"] 

attribute "lb/service/region",
  :display_name => "Load Balance Service Region",
  :description =>
    "For Rackspace's Cloud Load Balancing service region," +
    " specify the cloud region or data center being used for this service." +
    " Example: ORD (Chicago)",
  :required => "optional",
  :default => "ORD (Chicago)",
  :choice => ["ORD (Chicago)", "DFW (Dallas/Ft. Worth)", "LON (London)"]

attribute "lb/service/lb_name",
  :display_name => "Load Balance Service Name",
  :description =>
    "Name of the Cloud Load Balancer or Elastic Load Balancer device." +
    " Example: mylb",
  :required => "optional"
  
attribute "lb/service/account_id",
  :display_name => "Load Balance Service ID",
  :description =>
    "The account name that is required for access to specified" +
    " cloud load balancer. For Rackspace's CLB service," +
    " use your Rackspace username. (e.g., cred: RACKSPACE_USERNAME)." +
    " For Amazon ELB, use your Amazon key ID (e.g., cred:AWS_ACCESS_KEY_ID)." +
    " Example: cred:CLOUD_ACCOUNT_USERNAME",
  :required => "optional"

attribute "lb/service/account_secret",
  :display_name => "Load Balance Service Secret",
  :description =>
    "The account secret that is required for access to" +
    " specified cloud load balancer. For Rackspace's CLB service," +
    " use your Rackspace account API key (e.g., cred:RACKSPACE_AUTH_KEY)." +
    " For Amazon ELB, use your Amazon secret key" +
    " (e.g., cred:AWS_SECRET_ACCESS_KEY). Example: cred:CLOUD_ACCOUNT_KEY",
  :required => "optional"
