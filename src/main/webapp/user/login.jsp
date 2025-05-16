<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
</head>
<body>
<div class="login-wrapper">
    <div class="login-container">
        <div class="login-header">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="平台Logo" class="logo-image">
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
                <p>您已成功注销</p>
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
                <input type="text" id="username" name="username" value="<c:out value='${not empty requestScope.username ? requestScope.username : param.username}'/>" placeholder="请输入用户名" required>
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" placeholder="请输入密码" required>
            </div>
            <div class="form-group">
                <label for="captcha">验证码</label>
                <div class="captcha-row">
                    <input type="text" id="captcha" name="captcha" placeholder="结果" required autocomplete="off">
                    <img id="captchaImage" src="${pageContext.request.contextPath}/captchaImage" alt="验证码图片" title="点击刷新验证码">
                </div>
            </div>
            <div class="form-group">
                <button type="submit" class="btn-login">登 录</button>
            </div>
        </form>
        <div class="register-link">
            <p>还没有账户? <a href="${pageContext.request.contextPath}/register">立即注册</a></p>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var captchaImage = document.getElementById('captchaImage');
        if (captchaImage) {
            captchaImage.addEventListener('click', function() {
                this.src = '${pageContext.request.contextPath}/captchaImage?r=' + Math.random();
            });
        }

        // 如果登录失败，自动聚焦到第一个错误字段或验证码字段
        <c:if test="${not empty requestScope.errorMessage}">
        var captchaInput = document.getElementById('captcha');
        var usernameInput = document.getElementById('username');
        var passwordInput = document.getElementById('password');

        var errorMessageText = "<c:out value='${requestScope.errorMessage}'/>";

        if (errorMessageText.includes("验证码")) {
            if (captchaInput) captchaInput.focus();
        } else if (errorMessageText.includes("用户名")) {
            if (usernameInput) usernameInput.focus();
        } else if (errorMessageText.includes("密码")) {
            if (passwordInput) passwordInput.focus();
        } else {
            if (usernameInput) usernameInput.focus();
        }
        </c:if>
    });
</script>
</body>
</html>