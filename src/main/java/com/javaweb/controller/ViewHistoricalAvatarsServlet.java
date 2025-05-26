package com.javaweb.controller;

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User; // User 类中需要有 HistoricalAvatarPaths 内部类或等效的Bean

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/viewHistoricalAvatars")
public class ViewHistoricalAvatarsServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        User.HistoricalAvatarPaths historicalAvatars = userDAO.getHistoricalAvatars(userId);

        if (historicalAvatars == null) {
            // 创建一个空的 Paths 对象，避免JSP中出现空指针，或者在JSP中处理null
            historicalAvatars = new User.HistoricalAvatarPaths(null, null, null);
        }

        request.setAttribute("historicalAvatars", historicalAvatars);
        request.getRequestDispatcher("/user/historical_avatars.jsp").forward(request, response);
    }
}