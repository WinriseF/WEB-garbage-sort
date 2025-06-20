/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

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
import java.util.List;

/**
 * 这个Servlet负责处理对后台“上报管理列表”页面的请求。
 */
@WebServlet("/admin/reports/manage")
public class ManageReportsServlet extends HttpServlet {
    private EnvironmentalReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new EnvironmentalReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 安全检查：确保只有管理员能访问
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null || !"admin".equals(((User) session.getAttribute("loggedInUser")).getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        // 调用DAO，获取所有上报记录
        List<EnvironmentalReport> reportList = reportDAO.findAllReports();

        // 将列表存入request
        request.setAttribute("reportList", reportList);

        // 转发到JSP页面进行显示
        request.getRequestDispatcher("/admin/manage_reports.jsp").forward(request, response);
    }
}
