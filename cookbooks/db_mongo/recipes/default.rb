#
# Cookbook Name:: db_mongo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rightscale_marker :begin

%w{mongo bson bson_ext}.each { |pkg| 
  gem_package pkg do
    gem_binary "/usr/bin/gem"
    action :install
  end

  gem_package pkg do
    gem_binary "/opt/rightscale/sandbox/bin/gem"
    action :install
  end
}

gem_package "json" do
  gem_binary "/usr/bin/gem"
  version "1.2.4"
  action :install
end

gem_package "json" do
  gem_binary "/opt/rightscale/sandbox/bin/gem"
  version "1.2.4"
  action :install
end

Gem.clear_paths


rightscale_marker :end
