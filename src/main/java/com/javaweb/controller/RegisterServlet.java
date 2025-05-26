package com.javaweb.controller;

import com.javaweb.dao.UserDAO;
import com.javaweb.model.User;
import org.mindrot.jbcrypt.BCrypt;

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
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;

@WebServlet("/register")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    private static final String AVATAR_UPLOAD_DIR = "uploads" + File.separator + "avatars";//写入位置
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.removeAttribute("errorMessage"); // 清除之前的错误信息
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
        String userCaptchaInput = request.getParameter("captcha");

        Part avatarFilePart = request.getPart("avatarFile"); // "avatarFile" 对应 JSP 中 <input type="file"> 的 name 属性

        HttpSession session = request.getSession(); // 获取或创建会话
        String storedCaptchaAnswer = (String) session.getAttribute("captchaAnswer");

        if (storedCaptchaAnswer != null) {
            session.removeAttribute("captchaAnswer");
        }


        String errorMessage = null;
        //验证码校验
        if (userCaptchaInput == null || userCaptchaInput.trim().isEmpty()) {
            errorMessage = "请输入验证码！";
        } else if (storedCaptchaAnswer == null) {
            errorMessage = "验证码已失效，请刷新页面重试！";
        } else if (!userCaptchaInput.trim().equals(storedCaptchaAnswer)) {
            errorMessage = "验证码错误！";
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            setFormAttributes(request, username, email, nickname, ageGroup);
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }
        //基本校验
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
            //检查用户名和邮箱是否已存在
            if (userDAO.isUsernameExists(username)) {
                errorMessage = "用户名 '" + username + "' 已被注册！";
            } else if (email != null && !email.trim().isEmpty() && userDAO.isEmailExists(email)) {
                errorMessage = "邮箱 '" + email + "' 已被注册！";
            }
        }

        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            setFormAttributes(request, username, email, nickname, ageGroup);
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        } else {
            // 新增: 用于存储头像相对路径的变量
            String avatarRelativePath = null;

            // 新增: 处理头像上传的逻辑
            if (avatarFilePart != null && avatarFilePart.getSize() > 0) { // 检查是否有文件上传且文件不为空
                String originalFileName = Paths.get(avatarFilePart.getSubmittedFileName()).getFileName().toString(); // 获取原始文件名

                // 确保原始文件名有效
                if (originalFileName != null && !originalFileName.isEmpty()) {
                    String fileExtension = "";
                    int i = originalFileName.lastIndexOf('.');
                    if (i > 0) {
                        fileExtension = originalFileName.substring(i); // 获取文件扩展名，例如 ".jpg"
                    }

                    // 新增: 对文件扩展名进行简单校验
                    if (!fileExtension.toLowerCase().matches("\\.(jpg|jpeg|png|gif)$")) {
                        request.setAttribute("errorMessage", "头像文件格式无效，请上传 jpg, jpeg, png, 或 gif 格式的图片。");
                        setFormAttributes(request, username, email, nickname, ageGroup);
                        request.getRequestDispatcher("/user/register.jsp").forward(request, response);
                        return; // 停止处理
                    }

                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension; // 生成唯一的服务器文件名，防止重名
                    String appPath = request.getServletContext().getRealPath(""); // 获取 Web 应用在服务器上的绝对根路径
                    String uploadFilePath = appPath + File.separator + AVATAR_UPLOAD_DIR; // 完整的头像存储目录路径

                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) { // 如果目录不存在
                        if (!uploadDir.mkdirs()) { // 创建目录
                            // 记录错误，这通常是服务器配置或权限问题
                            System.err.println("无法创建头像上传目录: " + uploadFilePath);
                            request.setAttribute("errorMessage", "服务器错误：无法创建头像存储目录。");
                            setFormAttributes(request, username, email, nickname, ageGroup);
                            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
                            return; // 停止处理
                        }
                    }

                    File storeFile = new File(uploadDir, uniqueFileName); // 创建最终的头像文件对象
                    try (InputStream fileContent = avatarFilePart.getInputStream()) { // 获取上传文件的输入流
                        Files.copy(fileContent, storeFile.toPath(), StandardCopyOption.REPLACE_EXISTING); // 将文件内容复制到服务器目标文件
                        avatarRelativePath = AVATAR_UPLOAD_DIR + File.separator + uniqueFileName; // 构造存储在数据库中的相对路径
                        // 将路径中的反斜杠（Windows）替换为正斜杠（Web URL 标准）
                        avatarRelativePath = avatarRelativePath.replace(File.separator, "/");
                        System.out.println("头像已上传至: " + storeFile.getAbsolutePath() + " | 相对路径: " + avatarRelativePath);
                    } catch (IOException e) {
                        e.printStackTrace();
                        // 记录错误
                        request.setAttribute("errorMessage", "头像上传失败，请重试。");
                        setFormAttributes(request, username, email, nickname, ageGroup);
                        request.getRequestDispatcher("/user/register.jsp").forward(request, response);
                        return; // 停止处理
                    }
                }
            }
            //头像处理部分结束
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

            // 新增: 如果头像上传成功，将其相对路径设置到 newUser 对象中
            if (avatarRelativePath != null) {
                newUser.setCurrentAvatarPath(avatarRelativePath); // 假设 User 模型类有 setCurrentAvatarPath 方法
            }

            // 修改: 调用 addUser 方法，并期望它返回新用户的 user_id
            // 你需要修改 UserDAO.addUser() 方法的返回类型为 int (user_id)
            int newUserId = userDAO.addUser(newUser);

            if (newUserId > 0) { // addUser 成功并返回了有效的 user_id
                // 新增: 为新用户初始化历史头像记录
                // 你需要在 UserDAO 中实现 initializeHistoricalAvatars 方法
                if (!userDAO.initializeHistoricalAvatars(newUserId)) {
                    // 记录警告: 用户注册成功，但历史头像记录初始化失败。
                    // 这对用户来说可能不是致命错误，但后台需要记录。
                    System.err.println("警告: 用户 " + newUserId + " 注册成功, 但初始化历史头像记录失败。");
                }
                // 注册成功
                response.sendRedirect(request.getContextPath() + "/user/login.jsp?registered=true");
            } else {
                request.setAttribute("errorMessage", "注册失败，请稍后再试或联系管理员。");
                // 新增: 如果头像已上传但数据库操作失败，尝试删除已上传的文件以避免孤立文件
                if (avatarRelativePath != null) {
                    String appPath = request.getServletContext().getRealPath("");
                    // 将相对路径转换为绝对路径
                    File uploadedFile = new File(appPath + File.separator + avatarRelativePath.replace("/", File.separator));
                    if (uploadedFile.exists()) {
                        uploadedFile.delete();
                    }
                }
                setFormAttributes(request, username, email, nickname, ageGroup);
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            }
        }
    }
    private void setFormAttributes(HttpServletRequest request, String username, String email, String nickname, String ageGroup) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("nickname", nickname);
        request.setAttribute("ageGroup", ageGroup);
    }
}