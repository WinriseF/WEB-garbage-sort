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

@WebServlet("/admin/users/delete")
public class DeleteUserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查：确保只有管理员能执行此操作
        HttpSession session = request.getSession(false);
        if (session == null || !("admin".equals(((User)session.getAttribute("loggedInUser")).getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            // 1. 从URL中获取要删除的用户ID
            int userIdToDelete = Integer.parseInt(request.getParameter("id"));

            // 安全措施：防止管理员删除自己
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            if (userIdToDelete == loggedInUser.getUserId()) {
                // 如果试图删除自己，可以重定向回列表并附带一个错误消息（更友好的方式）
                // 这里我们简单地阻止操作
                System.out.println("Admin tried to delete self, operation aborted.");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 2. 指挥DAO执行删除操作
            userDAO.deleteUserById(userIdToDelete);

            // 3. 操作完成后，重定向回用户列表页面
            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            // 如果ID参数不是一个有效的数字
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的用户ID");
        }
    }
}
