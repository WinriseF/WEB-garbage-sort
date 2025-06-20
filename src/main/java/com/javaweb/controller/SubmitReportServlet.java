package com.javaweb.controller;

import com.javaweb.dao.EnvironmentalReportDAO;
import com.javaweb.model.EnvironmentalReport;
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
import java.nio.file.Paths;
import java.util.Date;
import java.util.UUID;

@WebServlet("/reports/submit")
@MultipartConfig
public class SubmitReportServlet extends HttpServlet {

    private EnvironmentalReportDAO reportDAO;
    private static final String UPLOAD_DIR_NAME = "uploads" + File.separator + "reports";

    @Override
    public void init() {
        reportDAO = new EnvironmentalReportDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        // 在处理任何数据前，首先检查用户是否登录
        if (currentUser == null) {
            // 如果未登录，设置一个明确的错误消息
            request.setAttribute("errorMessage", "您需要先登录才能提交上报！");
            // 为了用户体验，将用户已经填写的数据存回去，这样他们登录后不用重新填写
            request.setAttribute("reportType", request.getParameter("reportType"));
            request.setAttribute("description", request.getParameter("description"));
            request.setAttribute("addressText", request.getParameter("addressText"));
            // 将请求转发回表单页面，而不是重定向，这样才能传递错误消息和已填数据
            request.getRequestDispatcher("/reports/report_form.jsp").forward(request, response);
            return;
        }

        // --- 只有已登录用户才会执行下面的代码 ---

        int userId = currentUser.getUserId();
        String reportType = request.getParameter("reportType");
        String description = request.getParameter("description");
        String addressText = request.getParameter("addressText");

        Part filePart = request.getPart("photo");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String relativePathToSave = null;

        if (fileName != null && !fileName.isEmpty()) {
            String applicationPath = getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR_NAME;
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            relativePathToSave = UPLOAD_DIR_NAME.replace(File.separator, "/") + "/" + uniqueFileName;
        }

        EnvironmentalReport report = new EnvironmentalReport();
        report.setUserId(userId);
        report.setReportType(reportType);
        report.setDescription(description);
        report.setAddressText(addressText);
        report.setPhotoUrls(relativePathToSave);
        report.setReportedAt(new Date());
        report.setStatus("pending_review");

        boolean success = reportDAO.addReport(report);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/reports/feed");
        } else {
            request.setAttribute("errorMessage", "上报失败，请稍后重试。");
            request.getRequestDispatcher("/reports/report_form.jsp").forward(request, response);
        }
    }
}
