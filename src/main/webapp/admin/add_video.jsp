<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>添加新视频 - 后台管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container { max-width: 800px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group input[type="url"],
        .form-group textarea,
        .form-group select { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc; box-sizing: border-box; }
        .form-group textarea { resize: vertical; min-height: 100px; font-family: monospace; }
        .form-actions button { padding: 10px 20px; border: none; background-color: #007bff; color: white; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
<div class="form-container">
    <h1>添加新教育视频</h1>
    <a href="${pageContext.request.contextPath}/admin/videos/manage">« 返回视频管理列表</a>
    <hr style="margin: 20px 0;">

    <c:if test="${not empty errorMessage}">
        <p style="color:red;"><c:out value="${errorMessage}"/></p>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/videos/add" method="post">
        <div class="form-group">
            <label for="title">视频标题 (*)</label>
            <input type="text" id="title" name="title" required>
        </div>
        <div class="form-group">
            <label for="description">视频简介</label>
            <textarea id="description" name="description"></textarea>
        </div>
        <div class="form-group">
            <label for="videoIframe">B站嵌入代码 (*)</label>
            <%-- 关键修改：将input换成textarea，并修改name --%>
            <textarea id="videoIframe" name="videoIframe" placeholder="请在此处粘贴从B站分享功能复制的完整 <iframe> 代码" required></textarea>
        </div>
        <div class="form-group">
            <label for="thumbnailUrl">封面图片URL</label>
            <input type="url" id="thumbnailUrl" name="thumbnailUrl" placeholder="一个有效的图片链接">
        </div>
        <div class="form-group">
            <label for="status">状态 (*)</label>
            <select id="status" name="status">
                <option value="published" selected>已发布</option>
                <option value="pending">待审核</option>
            </select>
        </div>
        <div class="form-actions">
            <button type="submit">保存视频</button>
        </div>
    </form>
</div>
</body>
</html>
