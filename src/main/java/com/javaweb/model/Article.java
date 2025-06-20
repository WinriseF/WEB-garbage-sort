package com.javaweb.model;

import java.util.Date;

public class Article {
    private int articleId;
    private String title;
    private String contentHtml;
    private String summary;
    private Date publishDate;
    private int viewsCount;
    private int authorId;
    private String status;

    // --- Getter and Setter 方法 ---

    public int getArticleId() { return articleId; }
    public void setArticleId(int articleId) { this.articleId = articleId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContentHtml() { return contentHtml; }
    public void setContentHtml(String contentHtml) { this.contentHtml = contentHtml; }
    public String getSummary() { return summary; }
    public void setSummary(String summary) { this.summary = summary; }
    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }
    public int getViewsCount() { return viewsCount; }
    public void setViewsCount(int viewsCount) { this.viewsCount = viewsCount; }

    // 新字段的 Getter 和 Setter
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}