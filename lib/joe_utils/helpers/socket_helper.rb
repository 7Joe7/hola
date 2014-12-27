require 'socket'
require 'timeout'

module SocketHelper
  def is_port_open?(ip, port)
    begin
      Timeout::timeout(1) do
        s = TCPSocket.new(ip, port)
        s.close
        return true
      end
    rescue Timeout::Error, Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      # don't do anything
    end
    false
  end
end