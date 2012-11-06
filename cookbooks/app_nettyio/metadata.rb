maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures netty.io"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rightscale'
depends 'repo'
depends 'sys_firewall'
depends 'lb'

recipe "app_nettyio::default", "default recipe"

#Java tuning parameters
attribute "app_nettyio/main_class",
  :display_name => "JAVA Class to run",
  :description => "The java class to run the server.",
  :required => "optional",
  :default => "",
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