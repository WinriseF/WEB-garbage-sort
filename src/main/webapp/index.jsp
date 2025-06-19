<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>智能垃圾分类教育平台 - 首页</title>
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
                <div class="user-info">
                    <a href="${pageContext.request.contextPath}/user/profile.jsp">
                        <c:choose>
                            <c:when test="${not empty sessionScope.loggedInUser.currentAvatarPath}">
                                <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.currentAvatarPath}" alt="用户头像" class="user-avatar">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/logo.png" alt="默认头像" class="user-avatar">
                            </c:otherwise>
                        </c:choose>
                        <span class="user-info-text"><c:out value="${sessionScope.loggedInUser.nickname != null ? sessionScope.loggedInUser.nickname : sessionScope.loggedInUser.username}"/>!</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">注销</a>
                </div>
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
    <a href="${pageContext.request.contextPath}/games/game.jsp">分类游戏</a>
    <a href="${pageContext.request.contextPath}/reports/new">随手拍</a>
   <%-- <a href="${pageContext.request.contextPath}/recycling">旧物回收</a>--%>

    <%-- 管理后台入口 --%>
    <c:if test="${sessionScope.loggedInUser.role == 'admin'}">
        <a href="${pageContext.request.contextPath}/admin/dashboard">管理后台</a>
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

    <%-- 内容推荐区 --%>
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

</div>

<%-- 页脚 --%>
<footer class="footer">
    <p>© <fmt:formatDate value="<%=new java.util.Date()%>" pattern="yyyy"/> 智能垃圾分类教育平台. 保留所有权利.</p>
</footer>
</body>
</html>