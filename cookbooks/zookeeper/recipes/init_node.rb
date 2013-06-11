rightscale_marker :begin


bash "retrieve ip address of other nodes." do
    flags "-ex"
    code <<-EOH
    #!/bin/bash
    serverCount=0
    ips=`rs_tag --query zoonode:ip|grep zoonode|grep  -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`
    
    
    for i in $ips; do 
      serverCount=$((serverCount+1));echo server.$serverCount=$i:2888:3888 >> #{node[:zookeeper][:zooDir]}/conf/zoo.cfg;
          
          #create myid file - self identificaltion
          echo $i $serverCount
          echo #{@node[:cloud][:private_ips][0]} 
          if [ $i == #{@node[:cloud][:private_ips][0]} ]
            then
              echo $serverCount > #{node[:zookeeper][:configuration][:dataDir]}/myid
          fi
          
      
          
    done
    
    EOH
end



rightscale_marker :end