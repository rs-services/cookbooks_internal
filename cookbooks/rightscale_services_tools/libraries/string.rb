module RightScale
  module ServicesTools

    def check_input_length(input,length,message)
      raise message unless input.length >= length
    end

  end
end
