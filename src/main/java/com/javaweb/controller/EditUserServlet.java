package com.javaweb.controller;

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/users/edit")
public class EditUserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // 当点击“编辑”链接时，处理GET请求，显示编辑表单
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User userToEdit = userDAO.findById(userId); // 使用DAO查询用户信息

            if (userToEdit != null) {
                request.setAttribute("userToEdit", userToEdit); // 将用户信息存入request
                request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response); // 转发到JSP表单页
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "未找到指定用户");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的用户ID");
        }
    }

    // 当在编辑表单上点击“保存更改”时，处理POST请求
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            // 从表单获取所有数据
            int userId = Integer.parseInt(request.getParameter("userId"));
            String nickname = request.getParameter("nickname");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            boolean isActive = Boolean.parseBoolean(request.getParameter("isActive"));

            // 创建一个User对象封装更新后的数据
            User updatedUser = new User();
            updatedUser.setUserId(userId);
            updatedUser.setNickname(nickname);
            updatedUser.setEmail(email);
            updatedUser.setRole(role);
            updatedUser.setActive(isActive);

            // 调用DAO执行更新操作
            userDAO.updateUserByAdmin(updatedUser);

            // 操作完成后，重定向回用户列表页
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的用户ID");
        }
    }

    // 辅助方法，用于检查用户是否是管理员
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        return "admin".equals(user.getRole());
    }
}
