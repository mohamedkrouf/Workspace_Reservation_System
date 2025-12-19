package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

// New (uses Railway environment variables)
    private static final String MYSQL_HOST = System.getenv().getOrDefault("mysql.railway.internal", "localhost");
    private static final String MYSQL_USER = System.getenv().getOrDefault("root", "root");
    private static final String MYSQL_PASSWORD = System.getenv().getOrDefault("HSvxOPPNUuFVKuFCqiOXgLmqjefcyFJg", "");

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL connection failed: " + e.getMessage());
        }
    }
}
