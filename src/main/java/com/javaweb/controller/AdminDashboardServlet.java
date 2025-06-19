package com.javaweb.controller;

import com.javaweb.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查：确保只有管理员可以访问
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); // 未登录，重定向到登录页
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "访问被拒绝：您没有管理员权限。"); // 非管理员，返回403错误
            return;
        }

        // 转发到JSP仪表盘页面
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
