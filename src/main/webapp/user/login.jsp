<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
    <%-- 你也可以在这里引入一个通用的全局 CSS 文件，比如 reset.css 或 normalize.css --%>
</head>
<body>
<div class="login-wrapper">
    <div class="login-container">
        <div class="login-header">
            <%-- 可以放一个logo图片 --%>
            <%-- <img src="${pageContext.request.contextPath}/images/logo.png" alt="平台Logo" class="logo-image"> --%>
            <h2>用户登录</h2>
            <p>欢迎回到智能垃圾分类教育平台</p>
        </div>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="message error-message">
                <p>${requestScope.errorMessage}</p>
            </div>
        </c:if>
        <c:if test="${not empty param.logout}">
            <div class="message success-message">
                <p>您已成功注销。</p>
            </div>
        </c:if>
        <c:if test="${not empty param.registered}">
            <div class="message success-message">
                <p>注册成功！请登录。</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" value="${param.username}" placeholder="请输入用户名" required>
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" placeholder="请输入密码" required>
            </div>
            <%-- 可选：记住我 / 忘记密码
            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" name="rememberMe"> 记住我
                </label>
                <a href="#" class="forgot-password">忘记密码?</a>
            </div>
             --%>
            <div class="form-group">
                <button type="submit" class="btn-login">登 录</button>
            </div>
        </form>
        <div class="register-link">
            <p>还没有账户? <a href="${pageContext.request.contextPath}/register">立即注册</a></p>
        </div>
    </div>
</div>
</body>
</html>