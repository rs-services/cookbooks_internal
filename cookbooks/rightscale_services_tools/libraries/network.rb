module RightScale
  module ServicesTools

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
          s.close unless s.nil?
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
          s.close unless s.nil?
        end
      else
        raise "unsupported protocol"
      end
    end

    def check_connectivity(host,port,message,timeout=60)
      Chef::Log.info("Checking the connectivity of host: #{host} on port:#{port}")
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
