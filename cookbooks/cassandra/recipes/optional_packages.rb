#
# Cookbook Name:: cassandra
# Recipe:: optional_packages
#
# Copyright 2011, DataStax
#
# Apache License
#

###################################################
# 
# Install Optional Packages
# 
###################################################

# Addtional optional programs/utilities
case node[:platform]
  when "ubuntu", "debian"
    package "pssh"
    package "xfsprogs"
    package "maven2"
    package "git-core"

  when "centos", "redhat", "fedora"
    package "git"
end

package "python"
package "htop"
package "iftop"
package "pbzip2"
package "emacs"
package "sysstat"
package "zip"
package "unzip"
package "binutils"
package "ruby"
package "openssl"
package "ant"
package "curl"
