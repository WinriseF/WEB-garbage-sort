package com.javaweb.controller;

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/updateAvatar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class UpdateAvatarServlet extends HttpServlet {
    private UserDAO userDAO;
    // 与 RegisterServlet 保持一致的头像存储目录
    private static final String AVATAR_UPLOAD_DIR = "uploads" + File.separator + "avatars";

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // 初始化 UserDAO
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false); // 不创建新session

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login"); // 用户未登录
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();
        String oldCurrentAvatarPath = loggedInUser.getCurrentAvatarPath(); // 获取旧的当前头像路径

        Part newAvatarFilePart = request.getPart("newAvatarFile");
        String newAvatarRelativePath = null;
        String errorMessage = null;
        String successMessage = null;

        if (newAvatarFilePart == null || newAvatarFilePart.getSize() == 0) {
            errorMessage = "请选择一个头像文件。";
        } else {
            String originalFileName = Paths.get(newAvatarFilePart.getSubmittedFileName()).getFileName().toString();
            if (originalFileName != null && !originalFileName.isEmpty()) {
                String fileExtension = "";
                int i = originalFileName.lastIndexOf('.');
                if (i > 0) {
                    fileExtension = originalFileName.substring(i).toLowerCase();
                }

                if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)$")) {
                    errorMessage = "头像文件格式无效，请上传 jpg, jpeg, png, 或 gif 格式的图片。";
                } else {
                    // 使用 userID 和时间戳或UUID确保文件名唯一 (这里用UUID，因为时间戳可能在并发下不唯一)
                    String uniqueFileName = "user" + userId + "_" + UUID.randomUUID().toString().substring(0, 8) + fileExtension;
                    String appPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = appPath + File.separator + AVATAR_UPLOAD_DIR;

                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) {
                        if (!uploadDir.mkdirs()) {
                            System.err.println("UpdateAvatarServlet: 无法创建头像上传目录: " + uploadFilePath);
                            errorMessage = "服务器错误：无法更新头像。";
                        }
                    }

                    if (errorMessage == null) { // 目录创建成功或已存在
                        File storeFile = new File(uploadDir, uniqueFileName);
                        try (InputStream fileContent = newAvatarFilePart.getInputStream()) {
                            Files.copy(fileContent, storeFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                            newAvatarRelativePath = AVATAR_UPLOAD_DIR + File.separator + uniqueFileName;
                            newAvatarRelativePath = newAvatarRelativePath.replace(File.separator, "/");
                        } catch (IOException e) {
                            e.printStackTrace();
                            errorMessage = "头像上传失败，请重试。";
                        }
                    }
                }
            } else {
                errorMessage = "无效的文件名。";
            }
        }

        if (errorMessage == null && newAvatarRelativePath != null) {
            // 文件上传成功，现在更新数据库
            // 1. 获取旧的历史头像 (avatar1, avatar2)
            User.HistoricalAvatarPaths oldHistories = userDAO.getHistoricalAvatars(userId); // 需要在UserDAO中实现此方法

            // 2. 更新 Users 表中的 current_avatar_path
            boolean updateCurrentSuccess = userDAO.updateCurrentUserAvatar(userId, newAvatarRelativePath); // 需要在UserDAO中实现

            if (updateCurrentSuccess) {
                // 3. 更新 user_historical_avatars 表
                // 新的 hist1 是旧的 currentAvatarPath
                // 新的 hist2 是旧的 histAvatar1
                // 新的 hist3 是旧的 histAvatar2
                boolean updateHistorySuccess = userDAO.updateHistoricalAvatars(userId,
                        oldCurrentAvatarPath, // 这个成为新的 avatar1_path
                        (oldHistories != null ? oldHistories.getAvatar1() : null), // 旧的avatar1成为新的avatar2
                        (oldHistories != null ? oldHistories.getAvatar2() : null)  // 旧的avatar2成为新的avatar3
                ); // 需要在UserDAO中实现此方法

                if (updateHistorySuccess) {
                    successMessage = "头像更新成功！";
                    // 更新 session 中的用户信息
                    loggedInUser.setCurrentAvatarPath(newAvatarRelativePath);
                    session.setAttribute("loggedInUser", loggedInUser);

                    // 可选: 删除最旧的不再需要的历史头像文件 (原 avatar3_path 对应的文件)
                    // String avatarToDelete = (oldHistories != null ? oldHistories.getAvatar3() : null);
                    // if (avatarToDelete != null && !avatarToDelete.isEmpty()) {
                    //     File oldFile = new File(request.getServletContext().getRealPath("") + File.separator + avatarToDelete.replace("/", File.separator));
                    //     if (oldFile.exists()) oldFile.delete();
                    // }

                } else {
                    errorMessage = "头像已更新，但历史记录更新失败。请联系管理员。";
                    // 注意：此时当前头像已更新，但历史记录未同步，可能需要事务回滚或补偿逻辑
                }
            } else {
                errorMessage = "头像更新失败，数据库操作错误。";
                // 删除刚上传的文件，因为它没有被成功记录到数据库
                File uploadedFile = new File(request.getServletContext().getRealPath("") + File.separator + newAvatarRelativePath.replace("/", File.separator));
                if (uploadedFile.exists()) {
                    uploadedFile.delete();
                }
            }
        }
        // 设置消息并重定向回 profile 页面
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }
        // 不论成功失败，都转发回profile页面，让用户看到结果
        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }
}