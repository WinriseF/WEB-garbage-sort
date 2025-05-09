package com.javaweb.controller; // 替换为你的包名

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果用户已登录，尝试访问登录页，可以重定向到首页或其他地方
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp"); // 或用户主页
            return;
        }
        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.getUserByUsername(username);
        String errorMessage = null;

        if (user == null) {
            errorMessage = "用户名不存在！";
        } else if (!user.isActive()) {
            errorMessage = "您的账户已被禁用，请联系管理员。";
        } else if (!BCrypt.checkpw(password, user.getPasswordHash())) {
            errorMessage = "密码错误！";
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        } else {
            // 登录成功
            HttpSession session = request.getSession(); // 创建或获取会话
            session.setAttribute("loggedInUser", user); // 将 User 对象存入 session
            session.setAttribute("username", user.getUsername()); // 也可以单独存用户名等常用信息
            session.setAttribute("userRole", user.getRole());

            // 更新最后登录时间
            userDAO.updateLastLoginDate(user.getUserId());

            // 重定向到首页或其他受保护的页面
            // 可以根据用户角色重定向到不同页面
            if ("admin".equals(user.getRole()) || "editor".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp"); // 假设有后台管理页面
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); // 普通用户首页
            }
        }
    }
}