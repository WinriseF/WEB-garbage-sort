package com.javaweb.controller;

import com.javaweb.dao.ArticleDAO;
import com.javaweb.model.Article;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 文章控制器 (Servlet)
 * 映射到URL "/articles"，处理知识学习板块的所有请求
 */
@WebServlet("/articles")
public class ArticleServlet extends HttpServlet {
    private ArticleDAO articleDAO;

    @Override
    public void init() throws ServletException {
        // 在Servlet初始化时创建DAO实例
        articleDAO = new ArticleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取请求中的action参数，用于判断用户意图
        String action = request.getParameter("action");

        // 如果action为空或为"list"，则显示文章列表
        if (action == null || action.equals("list")) {
            listArticles(request, response);
        } else if (action.equals("view")) {
            // 如果action为"view"，则显示单篇文章详情
            viewArticle(request, response);
        } else {
            // 对于未知的action，可以重定向到列表页或显示错误
            listArticles(request, response);
        }
    }

    /**
     * 处理显示文章列表的逻辑
     */
    private void listArticles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Article> articleList = articleDAO.getAllPublishedArticles();
        request.setAttribute("articleList", articleList); // 将文章列表存入request作用域
        // 转发到JSP页面进行渲染
        request.getRequestDispatcher("/knowledge/articleList.jsp").forward(request, response);
    }

    /**
     * 处理显示单篇文章详情的逻辑
     */
    private void viewArticle(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 从请求中获取文章ID
            int articleId = Integer.parseInt(request.getParameter("id"));
            Article article = articleDAO.getArticleById(articleId);

            if (article != null) {
                request.setAttribute("article", article); // 将文章对象存入request作用域
                request.getRequestDispatcher("/knowledge/articleDetail.jsp").forward(request, response);
            } else {
                // 如果文章不存在或未发布，显示404错误
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "请求的文章未找到或未发布。");
            }
        } catch (NumberFormatException e) {
            // 如果ID参数不是有效的数字，显示400错误
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的文章ID格式。");
        }
    }
}