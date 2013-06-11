rightscale_marker :start

log "installing Sun java 1.6.0_31"

package "wget" do
  action :install
end

package "java-common" do
  action :install
end

package "unixodbc" do
  action :install
end


bash "install java" do
 flags "-ex"
 code <<-EOH
 #!/bin/bash

 PACKAGE_DIR=/root/sun_java_pkgs/

 #location to store deb packages
 mkdir $PACKAGE_DIR


 #download 2 jre and bin packages from s3
 cd $PACKAGE_DIR

 wget -q -O  sun-java6-jre_6.32-2~lucid1_all.deb 'http://rs-professional-services-publishing.s3.amazonaws.com/zookeeper/java/sun-java6-jre_6.32-2~lucid1_all.deb'
 wget -q -O  sun-java6-bin_6.32-2~lucid1_amd64.deb 'http://rs-professional-services-publishing.s3.amazonaws.com/zookeeper/java/sun-java6-bin_6.32-2~lucid1_amd64.deb'
 
 dpkg -i --force-depends *.deb

 java -version
 EOH
end



rightscale_marker :end