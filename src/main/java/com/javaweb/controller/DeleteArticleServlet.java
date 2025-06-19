package com.javaweb.controller;

import com.javaweb.dao.ArticleDAO;
import com.javaweb.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/articles/delete")
public class DeleteArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    @Override
    public void init() {
        articleDAO = new ArticleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");
        if (!"admin".equals(user.getRole()) && !"editor".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            int articleId = Integer.parseInt(request.getParameter("id"));
            articleDAO.deleteArticleById(articleId);
            response.sendRedirect(request.getContextPath() + "/admin/articles/manage");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的文章ID");
        }
    }
}
