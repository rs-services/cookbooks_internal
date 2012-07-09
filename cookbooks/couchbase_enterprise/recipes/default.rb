#
# Cookbook Name:: couchbase
# Recipe:: default
#
# Copyright 2012, RightScale
#
# All rights reserved - Do Not Redistribute
#
rs_utils_marker :begin
 
log "Couchbase Directory: #{node[:cb][:install_dir]}"

script "install_couchbase" do
  interpeter "perl"
  cwd "/tmp"
  code <<-EOH

if (`grep stranded /etc/rightscale.d/state.js `)
{
  print "Instance is stranded, aborting further operation.\n";
  exit -1 #leave without a smile
}

if ($ENV{'RS_REBOOT'})
{
   print "Skipping Couchbase install on a Reboot\n";
   exit 0 # Leave with a smile ...
}

print "Installing Couchbase:\n";
print "Installing package for: ";
open ISSUE, "/etc/issue";
$os = <ISSUE>;
close ISSUE;
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

print "Couchbase Server Enterprise Edition Installed.\n";
print "Setting version file:\n";

print "Done.\n";

sleep 2;

exit 0; 

 
  EOH
end

