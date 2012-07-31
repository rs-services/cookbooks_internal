require 'rubygems'
require 'oci8' 
require '/opt/oracle/.ora_creds/ora_creds.rb'

ora_conn = OCI8.new(@user, @pass, nil, :SYSDBA)
ora_conn.exec('select sysdate from dual') do |r| puts r.join(','); end

