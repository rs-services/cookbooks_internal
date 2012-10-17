module TestLib
  class String
    #http://stackoverflow.com/questions/1235863/test-if-a-string-is-basically-an-integer-in-quotes-using-ruby
    def integer? 
      [                          # In descending order of likeliness:
        /^[-+]?[1-9]([0-9]*)?$/, # decimal
        /^0[0-7]+$/,             # octal
        /^0x[0-9A-Fa-f]+$/,      # hexadecimal
        /^0b[01]+$/              # binary
      ].each do |match_pattern|
        return true if self =~ match_pattern
      end
      return false
    end
  end
  def do_input_checks
    do_min_port_check
    do_max_port_check
  end

  def do_min_port_check
    min_port=node['vsftpd']['min_port']
    raise "min_port is not an integer" unless min_port.integer?
    raise "min_port has to be larger then 1024" unless min_port.to_i >= 1024
  end

  def do_max_port_check
    #implement check
  end
end
