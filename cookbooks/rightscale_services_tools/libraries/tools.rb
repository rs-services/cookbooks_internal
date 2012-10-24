module RightScale
  module RightScaleServicesTools
    #has_connectivy(ip,port,proto,timeout)
    def has_connectivity(ip,port,proto = "tcp")
      require 'socket'
      require 'timeout'
      case proto
      when "tcp"
      begin
        s=TCPSocket.new(ip,port)
        return true
      rescue Errno::ECONNREFUSED => e
        return false
      ensure
        s.close
      end
      when "udp"
      begin
        s=UDPSocket.new
        s.connect(ip,port)
        s.write("\0")
        Timeout.timeout(1){s.read} 
        return true
      rescue Errno::ECONNREFUSED => e
        return false
      rescue Timeout::Error
        return true
      ensure 
        s.close
      end
      else
        raise "unsupported protocol"
      end
    end
  end
end
