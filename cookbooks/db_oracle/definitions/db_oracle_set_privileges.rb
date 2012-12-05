#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

define :db_oracle_set_privileges, :admin_username=>nil, :admin_password=>nil, :password => nil, :app_username=> nil,:app_password=> nil do

  admin_password = params[:admin_password]
  password = params[:password] # sys password
  admin_username = params[:admin_username]
  app_username = params[:app_username]
  app_password = params[:app_password]

  Gem.clear_paths
  log "admin_username:#{admin_username}, admin_password:#{admin_password}, password:#{password},app_username:#{app_username}, app_password:#{app_password}"
  ruby_block "set admin credentials" do
    block do
      require 'rubygems'
      ENV['ORACLE_HOME'] = '/opt/oracle/app/product/11.2.0/dbhome_1'
      ENV['LD_LIBRARY_PATH'] = '/opt/oracle/app/product/11.2.0/dbhome_1/lib:/opt/rightscale/sandbox/lib/ruby/site_ruby/1.8/x86_64-linux/'
      ENV['PATH'] = '/home/ec2/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/home/ec2/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin:/bin:/opt/oracle/app/product/11.2.0/dbhome_1:/opt/oracle/app/product/11.2.0/dbhome_1/bin:/usr/local/bin:/home/ec2/bin:/root/bin:/home/ec2/bin:/opt/oracle/app/product/11.2.0/dbhome_1:/opt/oracle/app/product/11.2.0/dbhome_1/bin:/usr/local/bin'
      ENV['ORACLE_SID'] = 'PROD'
      require 'oci8'
      con = OCI8.new('sys',password,nil, :SYSDBA)

      # Now that we have a oracle object, let's sanitize our inputs
      #admin_password = con.escape_string(admin_password)
      #password = con.escape_string(password)
      #admin_username = con.escape_string(admin_username)
      #app_username = con.escape_string(app_username)
      #app_password = con.escape_string(app_password)
      

      # Grant only the appropriate privs
      con.exec("CREATE USER  #{admin_username} IDENTIFIED BY #{admin_password}")
      con.exec("GRANT SYSDBA TO #{admin_username}")
      con.exec("CREATE USER  #{app_username} IDENTIFIED BY #{app_password}")
      con.exec("GRANT resource,connect TO #{app_username}")

    end
  end

end
