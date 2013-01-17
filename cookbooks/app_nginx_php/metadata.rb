maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures app_nginx_php"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "app"
depends "repo"
depends "rightscale"
depends "nginx"
depends "php-fpm"
depends "sys_firewall"

recipe "app_nginx_php::default", "Installs the php application server."

attribute "application/environment", 
  :display_name => "Application Environment",
  :description => "Application Environment -> Dev,Prod",
  :required => "required"
