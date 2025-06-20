/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;

import com.javaweb.dao.VideoDAO;
import com.javaweb.model.Video;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/videos")
public class VideoListServlet extends HttpServlet {
    private VideoDAO videoDAO;

    @Override
    public void init() {
        videoDAO = new VideoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Video> videoList = videoDAO.findAllPublished();
        request.setAttribute("videoList", videoList);
        request.getRequestDispatcher("/video/list.jsp").forward(request, response);
    }
}