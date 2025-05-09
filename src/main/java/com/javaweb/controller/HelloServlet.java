package com.javaweb.controller; // 根据你的包名修改

import com.javaweb.util.DBUtil; // 引入你的DBUtil

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/hello") // Servlet 3.0+ 注解方式配置
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Test</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Hello from HelloServlet (Java EE 8)!</h1>");

            // 测试数据库连接
            out.println("<h2>数据库连接测试:</h2>");
            try (Connection conn = DBUtil.getConnection()) {
                if (conn != null && !conn.isClosed()) {
                    out.println("<p style='color:green;'>数据库连接成功!</p>");
                    out.println("<p>数据库产品名称: " + conn.getMetaData().getDatabaseProductName() + "</p>");
                    out.println("<p>数据库产品版本: " + conn.getMetaData().getDatabaseProductVersion() + "</p>");
                } else {
                    out.println("<p style='color:red;'>数据库连接失败 (连接对象为null或已关闭).</p>");
                }
            } catch (SQLException e) {
                out.println("<p style='color:red;'>数据库连接异常: " + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(out); // 仅用于开发调试
                out.println("</pre>");
            } catch (Exception e) {
                out.println("<p style='color:red;'>发生未知错误: " + e.getMessage() + "</p>");
                out.println("<pre>");
                e.printStackTrace(out); // 仅用于开发调试
                out.println("</pre>");
            }

            out.println("</body>");
            out.println("</html>");
        }
    }
}