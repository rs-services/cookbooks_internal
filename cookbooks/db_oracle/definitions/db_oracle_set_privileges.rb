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


  ruby_block "set admin credentials" do
    block do
      require 'rubygems'
      require 'oci8'

      con = OCI8.new('sys',password,nil, :SYSDBA)

      # Now that we have a oracle object, let's sanitize our inputs
      admin_password = con.escape_string(admin_password)
      password = con.escape_string(password)
      admin_username = con.escape_string(admin_username)
      app_username = con.escape_string(app_username)
      app_password = con.escape_string(app_password)
      

      # Grant only the appropriate privs
      con.query("CREATE USER  #{admin_username} IDENTIFIED BY #{admin_password}")
      con.query("GRANT SYSDBA TO #{admin_username}")
      con.query("CREATE USER  #{app_username} IDENTIFIED BY #{app_password}")
      con.query("GRANT resource,connect TO #{app_username}")
 

      con.close
    end
  end

end
