<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>数据统计 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .stat-card { background-color: #fff; border-radius: 8px; padding: 25px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center; }
        .stat-card .stat-number { font-size: 3em; font-weight: bold; color: #007bff; margin: 0; }
        .stat-card .stat-title { font-size: 1.2em; color: #666; margin-top: 10px; }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>数据统计</h1>
        <a href="${pageContext.request.contextPath}/admin/dashboard">« 返回仪表盘</a>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <p class="stat-number">${totalUsers}</p>
            <p class="stat-title">注册用户总数</p>
        </div>
        <div class="stat-card">
            <p class="stat-number">${totalVideos}</p>
            <p class="stat-title">已发布视频总数</p>
        </div>
        <div class="stat-card">
            <p class="stat-number">${totalGamePlays}</p>
            <p class="stat-title">累计游戏总次数</p>
        </div>
    </div>

</div>
</body>
</html>
