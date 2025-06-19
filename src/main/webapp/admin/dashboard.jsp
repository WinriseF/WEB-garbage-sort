<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>管理后台 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #f4f7f6; }
        .admin-container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .admin-header h1 { margin: 0; }
        .admin-header a { text-decoration: none; color: #007bff; }
        .dashboard-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .dashboard-card { background-color: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center; }
        .dashboard-card h3 { margin-top: 0; }
        .dashboard-card p { color: #666; }
        .dashboard-card .card-link { display: inline-block; margin-top: 15px; padding: 8px 16px; background-color: #28a745; color: white; text-decoration: none; border-radius: 4px; }
        .dashboard-card .card-link:hover { background-color: #218838; }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>管理后台仪表盘</h1>
        <a href="${pageContext.request.contextPath}/">« 返回网站首页</a>
    </div>

    <div class="dashboard-grid">
        <!-- 内容管理卡片 -->
        <div class="dashboard-card">
            <h3>内容管理</h3>
            <p>管理视频、文章等教育内容。</p>
            <a href="${pageContext.request.contextPath}/admin/videos/manage" class="card-link">管理视频</a>
            <%-- <a href="#" class="card-link">管理文章</a> --%>
        </div>

        <!-- 用户管理卡片 -->
        <div class="dashboard-card">
            <h3>用户管理</h3>
            <p>查看、编辑或禁用平台用户。</p>
            <a href="${pageContext.request.contextPath}/admin/users" class="card-link">管理用户</a>
        </div>

        <!-- 数据统计卡片 -->
        <div class="dashboard-card">
            <h3>数据统计</h3>
            <p>查看网站关键数据和报告。</p>
            <a href="${pageContext.request.contextPath}/admin/stats" class="card-link">查看统计</a>
        </div>

    </div>
</div>
</body>
</html>
