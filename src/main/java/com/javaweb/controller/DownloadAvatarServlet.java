package com.javaweb.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;

@WebServlet("/downloadAvatar")
public class DownloadAvatarServlet extends HttpServlet {
    // 用于安全校验，确保下载请求只针对头像目录下的文件
    private static final String AVATAR_BASE_DIR_NAME = "uploads";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String avatarRelativePath = request.getParameter("path");

        if (avatarRelativePath == null || avatarRelativePath.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "请求的头像路径不能为空。");
            return;
        }

        // 安全性校验
        avatarRelativePath = avatarRelativePath.replace(File.separator, "/"); // 规范化路径
        if (!avatarRelativePath.startsWith(AVATAR_BASE_DIR_NAME + "/") || avatarRelativePath.contains("..")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "禁止访问的路径。");
            return;
        }

        String appPath = request.getServletContext().getRealPath("/");
        String fullPath = appPath + File.separator + avatarRelativePath.replace("/", File.separator);
        File avatarFile = new File(fullPath);

        if (!avatarFile.exists() || !avatarFile.isFile()) {
            System.err.println("DownloadAvatarServlet: 文件未找到或不是一个文件: " + fullPath);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "请求的头像文件未找到。");
            return;
        }

        // 设置响应头
        String mimeType = getServletContext().getMimeType(avatarFile.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLengthLong(avatarFile.length());

        String fileName = avatarFile.getName();
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);

        // 将文件内容写入响应输出流
        try (InputStream in = new FileInputStream(avatarFile);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        } catch (IOException e) {
            // 捕获IO异常
            System.err.println("DownloadAvatarServlet: 下载文件时发生IO错误: " + e.getMessage());
        }
    }
}