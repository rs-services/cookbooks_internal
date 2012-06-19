maintainer       "RightScale Professional Services"
maintainer_email "services@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures Oracle Java JDK"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "rs_utils"
recipe  "jdk::default", "Installs Java JDK 1.6.0_26-b3"

attribute "jdk/url",
  :display_name => "JDK Download URL",
  :description  => "URL from whence JDK should be downloaded.",
  :required     => "required",
  :recipes      => [ "jdk::default" ]
