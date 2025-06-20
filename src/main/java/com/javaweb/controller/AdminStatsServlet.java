/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;

import com.javaweb.dao.UserDAO;
import com.javaweb.dao.UserGameScoreDAO;
import com.javaweb.dao.VideoDAO;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/stats")
public class AdminStatsServlet extends HttpServlet {
    private UserDAO userDAO;
    private VideoDAO videoDAO;
    private UserGameScoreDAO userGameScoreDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        videoDAO = new VideoDAO();
        userGameScoreDAO = new UserGameScoreDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equals(((User)session.getAttribute("loggedInUser")).getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        // 1. 从各个DAO获取统计数据
        int totalUsers = userDAO.countTotalUsers();
        int totalVideos = videoDAO.countTotalPublishedVideos();
        int totalGamePlays = userGameScoreDAO.countTotalGamePlays();

        // 2. 将数据存入request，准备交给JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalVideos", totalVideos);
        request.setAttribute("totalGamePlays", totalGamePlays);

        // 3. 转发到JSP页面进行显示
        request.getRequestDispatcher("/admin/stats.jsp").forward(request, response);
    }
}
