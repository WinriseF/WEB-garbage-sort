package com.javaweb.controller;

import com.javaweb.dao.ArticleDAO;
import com.javaweb.model.Article;
import com.javaweb.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;

@WebServlet("/admin/articles/add")
public class AddArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    @Override
    public void init() {
        articleDAO = new ArticleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限访问此页面");
            return;
        }
        request.getRequestDispatcher("/admin/add_article.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "您没有权限执行此操作");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // 从表单获取标题和内容
        String title = request.getParameter("title");
        String contentHtml = request.getParameter("contentHtml");

        // 从Session中获取当前登录的用户
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");

        // 创建Article对象并填充所有需要的数据
        Article newArticle = new Article();
        newArticle.setTitle(title);
        newArticle.setContentHtml(contentHtml);
        newArticle.setPublishDate(new Date()); // 设置当前时间
        newArticle.setAuthorId(currentUser.getUserId()); // 设置作者ID为当前登录用户的ID
        newArticle.setStatus("published"); // 设置状态为已发布

        // 调用DAO
        boolean success = articleDAO.addArticle(newArticle);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/articles");
        } else {
            request.setAttribute("errorMessage", "发布文章失败，请重试。");
            request.getRequestDispatcher("/admin/add_article.jsp").forward(request, response);
        }
    }

    // 权限检查辅助方法
    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            return false;
        }
        User user = (User) session.getAttribute("loggedInUser");
        return "admin".equals(user.getRole()) || "editor".equals(user.getRole());
    }
}
