<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- 如果需要格式化日期等 --%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能垃圾分类教育平台 - 首页</title>
    <%-- 引入 CSS 文件 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- 页头 --%>
<header class="header">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/">智能垃圾分类教育平台</a>
    </div>
    <nav class="user-nav">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <span>欢迎, <c:out value="${sessionScope.loggedInUser.nickname != null ? sessionScope.loggedInUser.nickname : sessionScope.loggedInUser.username}"/>!</span>
                <%-- 可选：我的账户链接
                <a href="${pageContext.request.contextPath}/user/profile">我的账户</a>
                --%>
                <a href="${pageContext.request.contextPath}/logout">注销</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">登录</a>
                <a href="${pageContext.request.contextPath}/register">注册</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<%-- 主导航栏 --%>
<nav class="main-nav">
    <a href="${pageContext.request.contextPath}/videos">教育视频</a>
    <a href="${pageContext.request.contextPath}/articles">知识学习</a>
    <a href="${pageContext.request.contextPath}/games">分类游戏</a>
    <a href="${pageContext.request.contextPath}/reports/new">随手拍</a> <%-- 假设 /reports/new 是提交举报的入口 --%>
    <a href="${pageContext.request.contextPath}/recycling">旧物回收</a>

    <%-- 管理员和编辑的特定导航 --%>
    <c:if test="${sessionScope.loggedInUser.role == 'admin' || sessionScope.loggedInUser.role == 'editor'}">
        <a href="${pageContext.request.contextPath}/admin/content">内容管理</a>
    </c:if>
    <c:if test="${sessionScope.loggedInUser.role == 'admin'}">
        <a href="${pageContext.request.contextPath}/admin/users">用户管理</a>
        <a href="${pageContext.request.contextPath}/admin/stats">数据统计</a>
    </c:if>
</nav>

<%-- 主要内容容器 --%>
<div class="container">
    <div class="welcome-banner">
        <h1>欢迎来到智能垃圾分类教育平台</h1>
        <p>学习垃圾分类知识，参与环保行动，共建绿色家园！</p>
        <c:if test="${empty sessionScope.loggedInUser}">
            <p><a href="${pageContext.request.contextPath}/register" class="btn btn-primary">立即加入我们</a></p>
        </c:if>
    </div>

    <%-- 内容推荐区 (示例 - 后续可以用 Servlet 动态加载) --%>
    <section class="content-section">
        <h2>精选内容</h2>
        <div class="content-grid">
            <div class="content-item">
                <h3>最新教育视频</h3>
                <p>这里可以展示最新上传的视频...</p>
                <a href="${pageContext.request.contextPath}/videos">查看更多视频 »</a>
            </div>
            <div class="content-item">
                <h3>热门知识文章</h3>
                <p>这里可以展示热门或最新的知识文章...</p>
                <a href="${pageContext.request.contextPath}/articles">阅读更多文章 »</a>
            </div>
            <div class="content-item">
                <h3>趣味分类小游戏</h3>
                <p>通过游戏轻松学习垃圾分类！</p>
                <a href="${pageContext.request.contextPath}/games/game.jsp">开始游戏 »</a>
            </div>
        </div>
    </section>

    <%-- 可以根据需要添加更多区域，例如平台动态等 --%>

</div>

<%-- 页脚 --%>
<footer class="footer">
    <p>© <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy"/> 智能垃圾分类教育平台. 保留所有权利.</p>
    <%-- <p><a href="#">关于我们</a> | <a href="#">联系方式</a> | <a href="#">隐私政策</a></p> --%>
</footer>

<%-- 引入 JS 文件 (如果需要) --%>
<%-- <script src="${pageContext.request.contextPath}/js/main.js"></script> --%>
</body>
</html>