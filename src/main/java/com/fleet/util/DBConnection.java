package com.fleet.util;
import java.sql.*;
/** Creates JDBC connections using environment-based credentials. */
public final class DBConnection { private DBConnection() {} public static Connection getConnection() throws SQLException { return DriverManager.getConnection(System.getenv().getOrDefault("DB_URL","jdbc:mysql://localhost:3306/autonomous_fleet"),System.getenv().getOrDefault("DB_USER","root"),System.getenv().getOrDefault("DB_PASSWORD","")); } }