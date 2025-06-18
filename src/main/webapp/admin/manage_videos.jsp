<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>视频内容管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container { max-width: 1200px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .admin-header .btn-add { background-color: #28a745; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
        .content-table { width: 100%; border-collapse: collapse; }
        .content-table th, .content-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .content-table th { background-color: #f8f9fa; }
        .action-links a { margin-right: 10px; text-decoration: none; }
        .action-links .edit { color: #007bff; }
        .action-links .delete { color: #dc3545; }
        .status-published { color: green; font-weight: bold; }
        .status-pending { color: orange; font-weight: bold; }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>视频内容管理</h1>
        <div>
            <a href="${pageContext.request.contextPath}/admin/videos/add" class="btn-add">+ 添加新视频</a>
            <a href="${pageContext.request.contextPath}/admin/dashboard" style="margin-left: 20px;">« 返回仪表盘</a>
        </div>
    </div>

    <table class="content-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>标题</th>
            <th>状态</th>
            <th>发布日期</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${videoList}" var="video">
            <tr>
                <td>${video.videoId}</td>
                <td><c:out value="${video.title}"/></td>
                <td>
                    <span class="status-${video.status}"><c:out value="${video.status}"/></span>
                </td>
                <td><fmt:formatDate value="${video.publishDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td class="action-links">
                    <a href="${pageContext.request.contextPath}/admin/videos/edit?id=${video.videoId}" class="edit">编辑</a>
                    <a href="${pageContext.request.contextPath}/admin/videos/delete?id=${video.videoId}" class="delete" onclick="return confirm('确定要删除视频“<c:out value="${video.title}"/>”吗？');">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
