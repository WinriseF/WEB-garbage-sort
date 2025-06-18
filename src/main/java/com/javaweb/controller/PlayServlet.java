package com.javaweb.controller;

import com.javaweb.dao.VideoDAO;
import com.javaweb.model.Video;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/play")
public class PlayServlet extends HttpServlet {
    private VideoDAO videoDAO;

    @Override
    public void init() {
        videoDAO = new VideoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int videoId = Integer.parseInt(request.getParameter("id"));
            Video video = videoDAO.findById(videoId);
            if (video != null) {
                request.setAttribute("video", video);
                request.getRequestDispatcher("/video/play.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "视频未找到");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的视频ID");
        }
    }
}