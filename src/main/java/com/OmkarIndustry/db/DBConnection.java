package com.OmkarIndustry.db;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("org.postgresql.Driver");
            // Double-check your password and port (usually 5432)
            con = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/industry_db", "postgres", "Akash@232005");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con; // If this returns null, you get the error in your image
    }
}