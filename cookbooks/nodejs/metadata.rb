maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures nodejs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.2"

depends "rightscale"

recipe "nodejs::default", "installs nodejs"
recipe "nodejs::npm_config_set", "sets npm config settings"
recipe "nodejs::npm_packages_install", "installs npm packages"

attribute "nodejs/npm/packages", 
  :display_name => "NPM Package List",
  :description => "NPM Package List",
  :required => "required", 
  :recipes => [ "nodejs::npm_packages_install" ]
