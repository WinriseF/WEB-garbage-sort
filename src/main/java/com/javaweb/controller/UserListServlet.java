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
import java.util.List;

// 这一行是关键，它告诉服务器这个Servlet负责处理 /admin/users 请求
@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查，确保只有管理员能访问
        HttpSession session = request.getSession(false);
        // 增加对 session 和 user 对象的 null 检查，让代码更健壮
        if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equals(((User)session.getAttribute("loggedInUser")).getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        // 调用DAO获取所有用户数据
        List<User> userList = userDAO.findAllUsers();

        // 将用户列表存入request中，准备交给JSP
        request.setAttribute("userList", userList);

        // 转发到我们的JSP页面进行显示
        request.getRequestDispatcher("/admin/user_list.jsp").forward(request, response);
    }
}
