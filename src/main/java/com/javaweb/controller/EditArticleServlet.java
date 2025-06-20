/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;
//编写文章逻辑
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

@WebServlet("/admin/articles/edit")
public class EditArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    @Override
    public void init() {
        articleDAO = new ArticleDAO();
    }

    // 处理GET请求：显示编辑表单
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        try {
            int articleId = Integer.parseInt(request.getParameter("id"));
            Article article = articleDAO.getArticleById(articleId);

            if (article != null) {
                request.setAttribute("article", article);
                request.getRequestDispatcher("/admin/edit_article.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "未找到指定文章");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的文章ID");
        }
    }

    // 处理POST请求：保存更新
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权访问");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            int articleId = Integer.parseInt(request.getParameter("articleId"));
            String title = request.getParameter("title");
            String contentHtml = request.getParameter("contentHtml");
            String status = request.getParameter("status");

            Article articleToUpdate = new Article();
            articleToUpdate.setArticleId(articleId);
            articleToUpdate.setTitle(title);
            articleToUpdate.setContentHtml(contentHtml);
            articleToUpdate.setStatus(status);

            articleDAO.updateArticle(articleToUpdate);

            response.sendRedirect(request.getContextPath() + "/admin/articles/manage");

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的文章ID");
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
