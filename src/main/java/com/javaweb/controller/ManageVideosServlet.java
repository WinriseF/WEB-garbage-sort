package com.javaweb.controller;

import com.javaweb.dao.VideoDAO;
import com.javaweb.model.User;
import com.javaweb.model.Video;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

// 将这个Servlet映射到一个新的、专门用于管理的路径
@WebServlet("/admin/videos/manage")
public class ManageVideosServlet extends HttpServlet {
    private VideoDAO videoDAO;

    @Override
    public void init() {
        videoDAO = new VideoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查：确保只有管理员或编辑能访问
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equals(user.getRole()) && !"editor".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        // 使用 findAll() 方法获取所有视频，而不仅仅是已发布的
        List<Video> allVideos = videoDAO.findAll();

        request.setAttribute("videoList", allVideos);
        request.getRequestDispatcher("/admin/manage_videos.jsp").forward(request, response);
    }
}
