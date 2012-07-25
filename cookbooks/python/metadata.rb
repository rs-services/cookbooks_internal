maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures python"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "python::default", "installs python, and set version"

attribute "python/version",
  :display_name => "Python Version", 
  :description => "Python Version to set",
  :required => "optional",
  :choices => [ "2.4", "2.6", "3.0" ],
  :default => "2.6"
