/*
Code from http://www.orafaq.com/wiki/JDBC
*/
import java.sql.*;
class Conn {
  public static void main (String[] args) throws Exception
  {
   Class.forName ("oracle.jdbc.OracleDriver");

   Connection conn = DriverManager.getConnection
     ("jdbc:oracle:thin:@//10.180.167.70:1521/PROD", "sysman", "");
   try {
     Statement stmt = conn.createStatement();
     try {
       ResultSet rset = stmt.executeQuery("select BANNER from SYS.V_");
       try {
         while (rset.next())
           System.out.println (rset.getString(1));   // Print col 1
       } 
       finally {
          try { rset.close(); } catch (Exception ignore) {}
       }
     } 
     finally {
       try { stmt.close(); } catch (Exception ignore) {}
     }
   } 
   finally {
     try { conn.close(); } catch (Exception ignore) {}
   }
  }
}
