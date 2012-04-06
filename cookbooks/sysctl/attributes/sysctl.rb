case node[:platform]
  when /centos|redhat/
    set_unless[:sysctl][:settings] = { 
      "kernel.shmmax" => "68719476736",
      "net.ipv4.tcp_syncookies" => "1",
      "kernel.core_uses_pid" => "0",
      "net.ipv4.conf.default.accept_source_route" => "0",
      "kernel.core_pattern" => "/opt/rightscale/crash/%u_%p_%e",
      "kernel.msgmax" => "65536",
      "net.ipv4.conf.default.rp_filter" => "1",
      "kernel.sysrq" => "0",
      "kernel.shmall" => "4294967296",
      "net.ipv4.ip_forward" => "0",
      "kernel.msgmnb" => "65536",
      "vm.swappiness" => "100",
      "net.ipv4.ip_forward" => "1"
    }
end
