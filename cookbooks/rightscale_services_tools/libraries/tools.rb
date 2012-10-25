module RightScale
  module ServicesTools
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
    def check_connectivity(host,port,message,timeout=60)
      counter=0
      while !has_connectivity(host,port)
        if counter > timeout
          counter+=1
          sleep 1
        else
          raise message
        end
      end
    end
  end
end
