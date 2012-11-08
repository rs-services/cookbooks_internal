maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "All rights reserved"
description      "Install and Configure Nettyio"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

depends 'rightscale'
depends 'repo'
depends 'sys_firewall'
depends 'lb'

recipe "app_nettyio::default", "default recipe"

#Java tuning parameters
attribute "app_nettyio/main_class",
  :display_name => "Netty.io Java class to run with arguments",
  :description => "The java class to run the server. Example: my.org.http.Server 8000",
  :required => "required",
  :recipes => [
  "app_nettyio::default"
]

#Java tuning parameters
attribute "app_nettyio/java/xms",
  :display_name => "Netty.io Java XMS",
  :description => "The java Xms argument. Example: 512m",
  :required => "optional",
  :default => "512m",
  :recipes => [
  "app_nettyio::default"
]

attribute "app_nettyio/java/xmx",
  :display_name => "Netty.io Java XMX",
  :description => "The java Xmx argument. Example: 512m",
  :required => "optional",
  :default => "512m",
  :recipes => [
  "app_nettyio::default"
]

attribute "app_nettyio/java/permsize",
  :display_name => "Netty.io Java PermSize",
  :description => "The java PermSize argument. Example: 256m",
  :required => "optional",
  :default => "256m",
  :recipes => [
  "app_nettyio::default"
]

attribute "app_nettyio/java/maxpermsize",
  :display_name => "Netty.io Java MaxPermSize",
  :description => "The java MaxPermSize argument. Example: 256m",
  :required => "optional",
  :default => "256m",
  :recipes => [
  "app_nettyio::default"
]

attribute "app_nettyio/java/newsize",
  :display_name => "Netty.io Java NewSize",
  :description => "The java NewSize argument. Example: 256m",
  :required => "optional",
  :default => "256m",
  :recipes => [
  "app_nettyio::default"
]

attribute "app_nettyio/java/maxnewsize",
  :display_name => "Netty.io Java MaxNewSize",
  :description => "The java MaxNewSize argument. Example: 256m",
  :required => "optional",
  :default => "256m",
  :recipes => [
  "app_nettyio::default",

]