<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>知识学习 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 960px; margin: 20px auto; padding: 20px; }
        .page-header { margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;}
        .page-header h1 { margin: 0; }
        .back-link { text-decoration: none; color: #007bff; }
        .article-item { border-bottom: 1px solid #eee; padding: 20px 0; }
        .article-item:last-child { border-bottom: none; }
        .article-item h3 a { text-decoration: none; color: #0056b3; font-size: 20px; }
        .article-item h3 a:hover { color: #007bff; }
        .article-item .summary { color: #666; margin-top: 10px; line-height: 1.6; }
        .article-item .meta { color: #999; font-size: 13px; margin-top: 10px; }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1>知识学习中心</h1>
        <a href="${pageContext.request.contextPath}/" class="back-link">« 返回首页</a>
    </div>

    <c:choose>
        <c:when test="${not empty articleList}">
            <c:forEach items="${articleList}" var="article">
                <div class="article-item">
                    <h3>
                        <a href="${pageContext.request.contextPath}/articles?action=view&id=${article.articleId}">
                            <c:out value="${article.title}"/>
                        </a>
                    </h3>
                    <p class="summary"><c:out value="${article.summary}"/></p>
                    <div class="meta">
                        <span>发布于: <fmt:formatDate value="${article.publishDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                        <span style="margin-left: 20px;">阅读量: ${article.viewsCount}</span>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p>管理员太懒了，还没有发布任何文章哦！</p>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
