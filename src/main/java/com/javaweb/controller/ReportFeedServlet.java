package com.javaweb.controller;

import com.javaweb.dao.EnvironmentalReportDAO;
import com.javaweb.model.EnvironmentalReport;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 这个Servlet负责处理对“问题广场”页面的请求。
 */
@WebServlet("/reports/feed")
public class ReportFeedServlet extends HttpServlet {
    private EnvironmentalReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new EnvironmentalReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. 调用DAO，获取所有公开的上报记录。
        // DAO的findAllPublicReports()方法返回的是 List<EnvironmentalReport>
        List<EnvironmentalReport> reportList = reportDAO.findAllPublicReports();

        // 2. 将获取到的列表存入request中，准备交给JSP
        request.setAttribute("reportList", reportList);

        // 3. 转发到JSP页面进行显示。JSP页面会统一将上报人显示为“一位热心市民”。
        request.getRequestDispatcher("/reports/report_feed.jsp").forward(request, response);
    }
}
