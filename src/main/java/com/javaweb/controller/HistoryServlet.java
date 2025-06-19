package com.javaweb.controller;

// 【关键修复】: 添加下面这一行，引入我们需要的DAO类
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
 * 这个Servlet负责处理对用户“提交历史”页面的请求。
 */
@WebServlet("/reports/history")
public class HistoryServlet extends HttpServlet {
    private EnvironmentalReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new EnvironmentalReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // 安全检查：确保用户已登录
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp"); // 未登录，跳转到登录页
            return;
        }

        User currentUser = (User) session.getAttribute("loggedInUser");
        // 调用DAO，根据当前用户ID查询其提交历史
        List<EnvironmentalReport> historyList = reportDAO.findReportsByUserId(currentUser.getUserId());

        // 将历史列表存入request
        request.setAttribute("historyList", historyList);
        // 转发到JSP页面进行显示
        request.getRequestDispatcher("/reports/history.jsp").forward(request, response);
    }
}
