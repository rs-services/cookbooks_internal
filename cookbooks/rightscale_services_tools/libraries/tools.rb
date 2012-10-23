module RightScale
  module RightScaleServicesTools
    #has_connectivy(ip,port,proto,timeout)

    def has_connectivity(ip,port,proto => "tcp")
      require 'socket'
      case proto
        when "tcp"
          s=TCPSocket.new
        when "udp"
          s=UDPSocket.new
        else
          raise "unsupported protocol"
        end
      begin
        s.connect(ip,port)
        return true
      rescue Errno::ECONNREFUSED => e
        return false
      end
    end
  end
end
