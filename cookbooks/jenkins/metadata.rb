maintainer       "RightScale Inc"
maintainer_email "premium@rightscale.com"
license          "Apache 2.0"
description      "Installs/Configures jenkins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.2"

depends "apt"
depends "rightscale"
depends "sys_firewall"
depends "yum"

supports "centos", "~> 6.3"
supports "redhat", "~> 6.3"
supports "ubuntu", "~> 12.04"

recipe "jenkins::install", "Installs and configures Jenkins."

attribute "jenkins/home",
  :description  => "Directory where Jenkins stores its configuration and working files (checkouts, build reports, artifacts, ...).",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "home",
  :required     => "recommended",
  :default      => "/var/lib/jenkins"

attribute "jenkins/java_cmd",
  :description  => "Java executable to run Jenkins. When left empty a suitable Java will try and be located.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "java_cmd",
  :required     => "optional",
  :default      => ""

attribute "jenkins/user",
  :description  => "Unix user account that runs the Jenkins daemon. Be careful when you change this, as you need to update permissions of 'jenkins/home' and /var/log/jenkins.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "user",
  :required     => "optional",
  :default      => "jenkins"

attribute "jenkins/java_options",
  :description  => "Options to pass to Java when running Jenkins.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "java_options",
  :required     => "optional",
  :default      => "-Djava.awt.headless=true"

attribute "jenkins/port",
  :description  => "The port should Jenkins listen on. Set to -1 to disable.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "port",
  :required     => "optional",
  :default      => "8080"

attribute "jenkins/ajp_port",
  :description  => "The ajp13 port Jenkins should listen on. Set to -1 to disable.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "ajp_port",
  :required     => "optional",
  :default      => "8009"

attribute "jenkins/debug_level",
  :description  => "Debug level for logs. The higher the value, the more verbose. 5 is INFO.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "debug_level",
  :required     => "optional",
  :default      => "5"

attribute "jenkins/enable_access_log",
  :description  => "Enable access logging?",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "enable_access_log",
  :required     => "optional",
  :default      => "no"

attribute "jenkins/handler_max",
  :description  => "Maximum number of HTTP worker threads.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "handler_max",
  :required     => "optional",
  :default      => "100"

attribute "jenkins/handler_idle",
  :description  => "Maximum number of idle HTTP worker threads.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "handler_max",
  :required     => "optional",
  :default      => "20"

attribute "jenkins/args",
  :description  => "Pass arbitrary arguments to Jenkins. Full option list: java -jar jenkins.war --help.",
  :recipes      => ["jenkins::install"],
  :type         => "string",
  :display_name => "args",
  :required     => "optional",
  :default      => ""
