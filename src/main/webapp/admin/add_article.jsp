<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>添加新文章 - 后台管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container { max-width: 960px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff;}
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group textarea { width: 100%; padding: 10px; border-radius: 4px; border: 1px solid #ccc; box-sizing: border-box; }
        .form-group textarea { resize: vertical; min-height: 400px; }
        .form-actions button { padding: 10px 20px; border: none; background-color: #007bff; color: white; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
<div class="form-container">
    <h1>撰写新知识文章</h1>
    <a href="${pageContext.request.contextPath}/admin/dashboard">« 返回仪表盘</a>
    <hr style="margin: 20px 0;">

    <c:if test="${not empty errorMessage}">
        <p style="color:red;"><c:out value="${errorMessage}"/></p>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/articles/add" method="post">
        <div class="form-group">
            <label for="title">文章标题 (*)</label>
            <input type="text" id="title" name="title" required>
        </div>
        <div class="form-group">
            <label for="contentHtml">文章内容 (*)</label>
            <textarea id="contentHtml" name="contentHtml" required placeholder="你可以在这里输入HTML代码，例如 <p>这是一个段落。</p> <strong>这是粗体。</strong>"></textarea>
        </div>
        <div class="form-actions">
            <button type="submit">发布文章</button>
        </div>
    </form>
</div>
</body>
</html>
