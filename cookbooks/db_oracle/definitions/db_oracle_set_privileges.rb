#
# Cookbook Name:: db_oracle
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

define :db_oracle_set_privileges, :username=>nil, :admin_password=>nil, :password => nil do

  admin_password = params[:admin_password]
  password = params[:password]
  username = params[:username]



  ruby_block "set admin credentials" do
    block do
      require 'rubygems'
      require 'oci8'

      con = OCI8.new('sys',password, :SYSDBA)

      # Now that we have a oracle object, let's sanitize our inputs
      admin_password = con.escape_string(admin_password)
      password = con.escape_string(password)
      username = con.escape_string(username)

      # Grant only the appropriate privs
      con.query("CREATE USER  #{username} IDENTIFIED BY #{admin_password}")
      con.query("GRANT SYSDBA TO #{username}")
 

      con.close
    end
  end

end
