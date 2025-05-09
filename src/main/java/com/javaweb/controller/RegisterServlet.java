package com.javaweb.controller; // 替换为你的包名

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/user/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 处理中文参数

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String nickname = request.getParameter("nickname");
        String ageGroup = request.getParameter("ageGroup");

        String errorMessage = null;

        // 1. 基本校验
        if (username == null || username.trim().isEmpty() ||
                password == null || password.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {
            errorMessage = "用户名和密码不能为空！";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "两次输入的密码不一致！";
        } else if (username.length() < 3 || username.length() > 50) {
            errorMessage = "用户名长度必须在3到50个字符之间！";
        } else if (password.length() < 6) {
            errorMessage = "密码长度至少需要6位！";
        } else {
            // 2. 检查用户名和邮箱是否已存在
            if (userDAO.isUsernameExists(username)) {
                errorMessage = "用户名 '" + username + "' 已被注册！";
            } else if (email != null && !email.trim().isEmpty() && userDAO.isEmailExists(email)) {
                // 只有当邮箱非空时才检查其唯一性
                errorMessage = "邮箱 '" + email + "' 已被注册！";
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            // 保留用户输入，以便回填表单 (除了密码)
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        } else {
            // 3. 创建 User 对象并进行注册
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPasswordHash(hashedPassword);
            newUser.setEmail((email != null && email.trim().isEmpty()) ? null : email); // 如果邮箱为空字符串，则设为null
            newUser.setNickname(nickname);
            newUser.setAgeGroup((ageGroup != null && ageGroup.isEmpty()) ? null : ageGroup);
            newUser.setRole("user"); // 默认新注册用户为 'user'
            newUser.setActive(true); // 默认激活
            newUser.setRegistrationDate(new Timestamp(new Date().getTime()));


            if (userDAO.addUser(newUser)) {
                // 注册成功，可以重定向到登录页面并附带成功消息
                response.sendRedirect(request.getContextPath() + "/user/login.jsp?registered=true");
            } else {
                request.setAttribute("errorMessage", "注册失败，请稍后再试或联系管理员。");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            }
        }
    }
}