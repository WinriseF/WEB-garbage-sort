/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/admin/videos/edit")
public class EditVideoServlet extends HttpServlet {
    private VideoDAO videoDAO;
    // 定义一个正则表达式来匹配 src="..." 中的URL
    private static final Pattern SRC_PATTERN = Pattern.compile("src=\"([^\"]+)\"");

    @Override
    public void init() {
        videoDAO = new VideoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            int videoId = Integer.parseInt(request.getParameter("id"));
            Video video = videoDAO.findById(videoId);

            if (video != null) {
                request.setAttribute("video", video);
                request.getRequestDispatcher("/admin/edit_video.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "未找到指定视频");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的视频ID");
        }
    }

    // 处理POST请求：保存更新
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            // 1. 从表单获取数据
            int videoId = Integer.parseInt(request.getParameter("videoId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            // 获取textarea的内容，参数名是 "videoIframe"
            String iframeCode = request.getParameter("videoIframe");
            String thumbnailUrl = request.getParameter("thumbnailUrl");
            String status = request.getParameter("status");

            // 2. 从iframe代码中提取src链接
            String videoUrl = extractSrcFromIframe(iframeCode);
            if (videoUrl == null || videoUrl.isEmpty()) {
                // 如果提取失败，可以返回错误，或者保留旧的URL。这里我们返回错误。
                request.setAttribute("errorMessage", "无法从嵌入代码中找到有效的视频URL，请检查代码是否正确。");
                // 为了能返回到正确的编辑页，需要重新加载旧数据
                Video oldVideo = videoDAO.findById(videoId);
                request.setAttribute("video", oldVideo);
                request.getRequestDispatcher("/admin/edit_video.jsp").forward(request, response);
                return;
            }

            // 3. 创建一个Video对象封装更新后的数据
            Video videoToUpdate = new Video();
            videoToUpdate.setVideoId(videoId);
            videoToUpdate.setTitle(title);
            videoToUpdate.setDescription(description);
            videoToUpdate.setVideoUrl(videoUrl); // 存储提取出的纯净URL
            videoToUpdate.setThumbnailUrl(thumbnailUrl);
            videoToUpdate.setStatus(status);

            // 4. 调用DAO执行更新操作
            videoDAO.updateVideo(videoToUpdate);

            // 5. 操作完成后，重定向回视频管理列表页
            response.sendRedirect(request.getContextPath() + "/admin/videos/manage");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的视频ID");
        }
    }

    // 智能提取src链接的辅助方法
    private String extractSrcFromIframe(String iframeCode) {
        if (iframeCode == null) return null;
        Matcher matcher = SRC_PATTERN.matcher(iframeCode);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return null;
    }

    // 用于检查用户权限
    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        return "admin".equals(user.getRole()) || "editor".equals(user.getRole());
    }
}
