/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // 数据库URL、用户名、密码
    private static final String URL = "jdbc:mysql://localhost:3306/ZNLJFL?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load MySQL JDBC driver.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}