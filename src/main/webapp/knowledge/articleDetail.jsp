<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title><c:out value="${article.title}" default="文章详情"/> - 智能垃圾分类教育平台</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .container { max-width: 960px; margin: 20px auto; padding: 20px; }
    .article-header h1 { font-size: 28px; }
    .article-header .meta { color: #999; font-size: 13px; margin: 10px 0; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .article-content { margin-top: 20px; line-height: 1.8; font-size: 16px; }
    .article-content img { max-width: 100%; height: auto; }
    .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; }
  </style>
</head>
<body>
<div class="container">
  <a href="${pageContext.request.contextPath}/articles" class="back-link">« 返回文章列表</a>

  <c:choose>
    <c:when test="${not empty article}">
      <div class="article-header">
        <h1><c:out value="${article.title}"/></h1>
        <div class="meta">
          <span>发布于: <fmt:formatDate value="${article.publishDate}" pattern="yyyy-MM-dd HH:mm"/></span>
          <span style="margin-left: 20px;">阅读量: ${article.viewsCount}</span>
        </div>
      </div>

      <div class="article-content">
          <%-- 直接输出HTML内容 --%>
          ${article.contentHtml}
      </div>
    </c:when>
    <c:otherwise>
      <h1>文章未找到</h1>
      <p>很抱歉，您要查看的文章不存在或已被删除。</p>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
