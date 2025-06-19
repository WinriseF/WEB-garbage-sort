<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑视频 - 管理后台</title>
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
    <h1>编辑视频</h1>
    <a href="${pageContext.request.contextPath}/admin/videos/manage">« 返回视频管理列表</a>
    <hr style="margin: 20px 0;">

    <form action="${pageContext.request.contextPath}/admin/videos/edit" method="post">
        <input type="hidden" name="videoId" value="${video.videoId}">
        <div class="form-group">
            <label for="title">视频标题 (*)</label>
            <input type="text" id="title" name="title" value="<c:out value='${video.title}'/>" required>
        </div>
        <div class="form-group">
            <label for="description">视频简介</label>
            <textarea id="description" name="description"><c:out value='${video.description}'/></textarea>
        </div>
        <div class="form-group">
            <label for="videoIframe">B站嵌入代码 (*)</label>
            <textarea id="videoIframe" name="videoIframe" required><iframe src="${video.videoUrl}" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe></textarea>
        </div>
        <div class="form-group">
            <label for="thumbnailUrl">封面图片URL</label>
            <input type="url" id="thumbnailUrl" name="thumbnailUrl" value="<c:out value='${video.thumbnailUrl}'/>">
        </div>
        <div class="form-group">
            <label for="status">状态 (*)</label>
            <select id="status" name="status">
                <option value="published" ${video.status == 'published' ? 'selected' : ''}>已发布</option>
                <option value="pending" ${video.status == 'pending' ? 'selected' : ''}>待审核</option>
                <option value="archived" ${video.status == 'archived' ? 'selected' : ''}>已归档</option>
            </select>
        </div>
        <div class="form-actions">
            <button type="submit">保存更改</button>
        </div>
    </form>
</div>
</body>
</html>
