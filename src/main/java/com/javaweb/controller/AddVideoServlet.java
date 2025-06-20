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
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/admin/videos/add")
public class AddVideoServlet extends HttpServlet {
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问此页面");
            return;
        }
        // 转发到JSP表单页面
        request.getRequestDispatcher("/admin/add_video.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限执行此操作");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // 1. 从表单获取数据
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        // 获取textarea的内容，参数名是JSP中定义的 "videoIframe"
        String iframeCode = request.getParameter("videoIframe");
        String thumbnailUrl = request.getParameter("thumbnailUrl");
        String status = request.getParameter("status");

        // 2. 从iframe代码中提取src链接
        String videoUrl = extractSrcFromIframe(iframeCode);
        if (videoUrl == null || videoUrl.isEmpty()) {
            request.setAttribute("errorMessage", "无法从嵌入代码中找到有效的视频URL，请检查代码是否正确。");
            request.getRequestDispatcher("/admin/add_video.jsp").forward(request, response);
            return;
        }

        // 3. 从Session获取当前登录用户的ID作为上传者ID
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // 4. 创建一个新的Video对象并填充数据
        Video newVideo = new Video();
        newVideo.setTitle(title);
        newVideo.setDescription(description);
        newVideo.setVideoUrl(videoUrl); // 存储提取出的纯净URL
        newVideo.setThumbnailUrl(thumbnailUrl);
        newVideo.setStatus(status);
        newVideo.setUploaderId(loggedInUser.getUserId());
        newVideo.setPublishDate(new Date()); // 设置当前时间为发布时间

        // 5. 调用DAO将视频存入数据库
        boolean success = videoDAO.addVideo(newVideo);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/videos/manage");
        } else {
            request.setAttribute("errorMessage", "添加视频失败，请检查您的输入并重试。");
            request.getRequestDispatcher("/admin/add_video.jsp").forward(request, response);
        }
    }

    // 智能提取src链接的辅助方法
    private String extractSrcFromIframe(String iframeCode) {
        if (iframeCode == null) return null;
        Matcher matcher = SRC_PATTERN.matcher(iframeCode);
        if (matcher.find()) {
            return matcher.group(1); // 返回第一个捕获组的内容，即src链接
        }
        return null;
    }

    // 辅助方法，用于检查用户权限
    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // false表示不创建新session
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        // 只有 'admin' 或 'editor' 角色的用户才有权限
        return "admin".equals(user.getRole()) || "editor".equals(user.getRole());
    }
}
