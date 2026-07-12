package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Edit user and password below to match your SQL Server setup
            String user = "sa";
            String pass = "123456";
            // Check your SQL Server port, default is 1433
            String url = "jdbc:sqlserver://localhost:1433;databaseName=Travel_Company;encrypt=false";
            
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}