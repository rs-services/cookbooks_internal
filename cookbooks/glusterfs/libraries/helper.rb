module GlusterFS
  class Error
    def self.check(file, topic)
      if open(file) { |f| f.grep(/\bsuccessful\b/) }.empty?
        Chef::Log.fatal "!!!> #{topic} failed:"
        begin
          raise File.read(file) if File.exists?(file)
        ensure
          File.unlink(file) if File.exists?(file)
        end
      end
    end
  end #class 
end #module 
