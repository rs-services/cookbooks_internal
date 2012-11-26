module TestLib
    #http://stackoverflow.com/questions/1235863/test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
  def integer?(value)
    [                          # In descending order of likeliness:
      /^[-+]?[1-9]([0-9]*)?$/, # decimal
      /^0[0-7]+$/,             # octal
      /^0x[0-9A-Fa-f]+$/,      # hexadecimal
      /^0b[01]+$/              # binary
    ].each do |match_pattern|
      return true if value =~ match_pattern
    end
    return false
  end
  def do_input_checks(min_port,max_port)
    do_min_port_check(min_port)
    do_max_port_check(max_port)
  end

  def do_min_port_check(min_port)
    puts "min_port"
    raise "min_port is not an integer" unless integer?(min_port)
    raise "min_port has to be larger then 1024" unless min_port.to_i >= 1024
  end

  def do_max_port_check(max_port)
    raise "max_port is not an integer" unless integer?(max_port)
    raise "max_port can not exceed 65535" unless max_port.to_i <= 65535
    if (max_port.to_i - min_port.to_i) < 1 then
      raise "there should be at least one port in the min/max port range"
    end
  end
end
