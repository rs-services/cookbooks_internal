maintainer       "Rightscale Inc"
maintainer_email "edwin@rightscale.com"
license          "All rights reserved"
description      "Installs/Configures zookeeper"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends 'rightscale'

recipe "zookeeper::init_node", "Initiate Zookeeper Node"
recipe "zookeeper::add_zoo_tag", "Adds Zookeeper Node Tag"
recipe "zookeeper::install_java", "Installs Java"
recipe "zookeeper::install", "Installs Zookeeper"
recipe "zookeeper::stop", "Stop Zookeeper"
recipe "zookeeper::start", "Start Zookeeper"