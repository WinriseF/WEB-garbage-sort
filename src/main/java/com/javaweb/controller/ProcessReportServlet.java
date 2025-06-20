package com.javaweb.controller;

import com.javaweb.dao.EnvironmentalReportDAO;
import com.javaweb.model.EnvironmentalReport;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 这个Servlet负责处理对单个上报记录的查看与更新。
 */
@WebServlet("/admin/reports/process")
public class ProcessReportServlet extends HttpServlet {
    private EnvironmentalReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new EnvironmentalReportDAO();
    }

    // 显示单个上报的详情和处理表单
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equals(((User)session.getAttribute("loggedInUser")).getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            int reportId = Integer.parseInt(request.getParameter("id"));
            EnvironmentalReport report = reportDAO.findReportById(reportId);
            if (report != null) {
                request.setAttribute("report", report);
                request.getRequestDispatcher("/admin/process_report.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "未找到该上报记录");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的上报ID");
        }
    }

    // 处理状态更新的提交
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equals(((User)session.getAttribute("loggedInUser")).getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            int reportId = Integer.parseInt(request.getParameter("reportId"));
            String newStatus = request.getParameter("status");
            String adminNotes = request.getParameter("adminNotes");

            reportDAO.updateReportStatus(reportId, newStatus, adminNotes);

            // 处理完成后，重定向回管理列表页
            response.sendRedirect(request.getContextPath() + "/admin/reports/manage");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的上报ID");
        }
    }
}
