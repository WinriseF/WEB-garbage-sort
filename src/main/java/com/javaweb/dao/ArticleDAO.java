package com.javaweb.dao;

import com.javaweb.model.Article;
import com.javaweb.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {

    /**
     * 获取所有文章（无论状态），用于后台管理列表。
     * @return 包含所有文章的列表。
     */
    public List<Article> findAllArticles() {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT article_id, title, status, publish_date FROM knowledgearticles ORDER BY publish_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Article article = new Article();
                article.setArticleId(rs.getInt("article_id"));
                article.setTitle(rs.getString("title"));
                article.setStatus(rs.getString("status"));
                article.setPublishDate(rs.getTimestamp("publish_date"));
                articles.add(article);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }

    /**
     * 获取所有已发布的文章列表 (用于前台文章列表页)
     */
    public List<Article> getAllPublishedArticles() {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT article_id, title, content_html, publish_date, views_count FROM knowledgearticles WHERE status = 'published' ORDER BY publish_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Article article = new Article();
                article.setArticleId(rs.getInt("article_id"));
                article.setTitle(rs.getString("title"));

                String rawContent = rs.getString("content_html");

                // 使用更强大的正则表达式进行深度清洁
                String noScriptsOrStyles = rawContent.replaceAll("(?is)<(script|style).*?>.*?</\\1>", "");
                String plainTextContent = noScriptsOrStyles.replaceAll("<[^>]*>", "");
                plainTextContent = plainTextContent.replaceAll("&nbsp;", " ").trim();

                // 生成摘要
                if (plainTextContent.length() > 150) {
                    article.setSummary(plainTextContent.substring(0, 150) + "...");
                } else {
                    article.setSummary(plainTextContent);
                }

                article.setPublishDate(rs.getTimestamp("publish_date"));
                article.setViewsCount(rs.getInt("views_count"));
                articles.add(article);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }

    /**
     * 根据ID获取单篇文章的详细信息 (用于前台详情页和后台编辑页)
     */
    public Article getArticleById(int articleId) {
        Article article = null;
        String sql = "SELECT * FROM knowledgearticles WHERE article_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, articleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    article = new Article();
                    article.setArticleId(rs.getInt("article_id"));
                    article.setTitle(rs.getString("title"));
                    article.setContentHtml(rs.getString("content_html"));
                    article.setPublishDate(rs.getTimestamp("publish_date"));
                    article.setViewsCount(rs.getInt("views_count"));
                    article.setAuthorId(rs.getInt("author_id"));
                    article.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return article;
    }


    /**
     * 向数据库中插入一篇新的文章。
     */
    public boolean addArticle(Article article) {
        String sql = "INSERT INTO knowledgearticles (title, content_html, author_id, publish_date, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, article.getTitle());
            pstmt.setString(2, article.getContentHtml());
            pstmt.setInt(3, article.getAuthorId());
            pstmt.setTimestamp(4, new java.sql.Timestamp(article.getPublishDate().getTime()));
            pstmt.setString(5, article.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 根据ID删除一篇文章。
     */
    public boolean deleteArticleById(int articleId) {
        String sql = "DELETE FROM knowledgearticles WHERE article_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, articleId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * 更新一篇已存在的文章。
     * @param article 包含更新后信息的 Article 对象。
     * @return 如果更新成功，返回 true；否则返回 false。
     */
    public boolean updateArticle(Article article) {
        String sql = "UPDATE knowledgearticles SET title = ?, content_html = ?, status = ? WHERE article_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, article.getTitle());
            pstmt.setString(2, article.getContentHtml());
            pstmt.setString(3, article.getStatus());
            pstmt.setInt(4, article.getArticleId()); // 根据ID更新

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
