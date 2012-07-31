require 'rubygems'
require 'oci8' 
require '/opt/oracle/.ora_creds/ora_creds.rb'
OCI8.new(@user, @pass, nil, :SYSDBA).exec('select sysdate from dual') do |r|
  puts "Getting Date From Oracle: #{r.join(',');}"
end
