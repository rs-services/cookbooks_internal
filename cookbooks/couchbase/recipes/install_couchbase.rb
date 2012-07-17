#
# Cookbook Name:: couchbase
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin
 
log "Couchbase Directory: #{node[:couchbase][:install_dir]}"

log "Package which will be installed couchbase"
  package "couchbase-server-enterprise" do
  action :install
  end

log "Couchbase Server Enterprise Edition Installed.";


rs_utils_marker :end


#  OLD INSTALL SCRIPTS
if( $os =~ /CentOS.*?/){
        print "Centos:\n";
        $x = `/bin/rpm -i $ENV{'ATTACH_DIR'}/couchbase-server-enterprise\*.rpm`;
}
elsif( $os =~ /Ubuntu.*?/){
        print "Ubuntu:\n";
        $x = `/usr/bin/dpkg -i $ENV{'ATTACH_DIR'}/couchbase-server-enterprise\*.deb`;
}
else
{
        print "Can't determine OS version!\n";
        exit -1; #leave without a smile
}



