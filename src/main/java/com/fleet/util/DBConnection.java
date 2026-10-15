package com.fleet.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC driver could not be loaded", e
            );
        }

        String url = System.getenv().getOrDefault(
            "DB_URL",
            "jdbc:mysql://localhost:3306/autonomous_fleet"
        );

        String user = System.getenv().getOrDefault("DB_USER", "root");
        String password = System.getenv().getOrDefault("DB_PASSWORD", "");

        return DriverManager.getConnection(url, user, password);
    }
}
