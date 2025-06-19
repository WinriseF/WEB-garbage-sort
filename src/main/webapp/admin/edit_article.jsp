<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑文章 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container { max-width: 960px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff;}
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select { width: 100%; padding: 10px; border-radius: 4px; border: 1px solid #ccc; box-sizing: border-box; }
        .form-group textarea { resize: vertical; min-height: 400px; }
        .form-actions button { padding: 10px 20px; border: none; background-color: #007bff; color: white; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
<div class="form-container">
    <h1>编辑文章</h1>
    <a href="${pageContext.request.contextPath}/admin/articles/manage">« 返回文章管理列表</a>
    <hr style="margin: 20px 0;">

    <form action="${pageContext.request.contextPath}/admin/articles/edit" method="post">

        <input type="hidden" name="articleId" value="${article.articleId}">

        <div class="form-group">
            <label for="title">文章标题 (*)</label>
            <input type="text" id="title" name="title" value="<c:out value='${article.title}'/>" required>
        </div>
        <div class="form-group">
            <label for="contentHtml">文章内容 (*)</label>
            <textarea id="contentHtml" name="contentHtml" required><c:out value='${article.contentHtml}'/></textarea>
        </div>
        <div class="form-group">
            <label for="status">状态 (*)</label>
            <select id="status" name="status">
                <option value="published" ${article.status == 'published' ? 'selected' : ''}>已发布</option>
                <option value="draft" ${article.status == 'draft' ? 'selected' : ''}>草稿</option>
                <option value="archived" ${article.status == 'archived' ? 'selected' : ''}>已归档</option>
            </select>
        </div>

        <div class="form-actions">
            <button type="submit">保存更改</button>
        </div>
    </form>
</div>
</body>
</html>

