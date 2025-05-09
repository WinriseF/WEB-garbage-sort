<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 智能垃圾分类教育平台</title>
    <%-- 引用与登录页面相同的CSS文件，或者一个包含共同样式的CSS文件 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
    <%-- 如果有注册页面特有的样式，可以再引用一个 register-specific.css --%>
</head>
<body>
<div class="login-wrapper"> <%-- 复用 login-wrapper 实现整体布局 --%>
    <div class="login-container register-container"> <%-- 复用 login-container，可以加一个 register-container 类以便微调 --%>
        <div class="login-header">
            <h2>创建您的账户</h2>
            <p>加入我们，一起学习垃圾分类！</p>
        </div>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="message error-message">
                <p>${requestScope.errorMessage}</p>
            </div>
        </c:if>
        <%-- 注册页面通常不需要显示 “您已成功注销” 或 “注册成功！请登录” --%>
        <%-- 如果有注册后的成功消息，通常是 RegisterServlet 直接处理或重定向 --%>
        <c:if test="${not empty requestScope.successMessage}"> <%-- 如果你确实有成功消息要显示在这里 --%>
            <div class="message success-message">
                <p>${requestScope.successMessage}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="login-form">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" value="${param.username}" placeholder="3-50位字符" required>
            </div>
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" placeholder="至少6位字符" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">确认密码</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="再次输入密码" required>
            </div>
            <div class="form-group">
                <label for="email">邮箱 (可选)</label>
                <input type="email" id="email" name="email" value="${param.email}" placeholder="例如: user@example.com">
            </div>
            <div class="form-group">
                <label for="nickname">昵称 (可选)</label>
                <input type="text" id="nickname" name="nickname" value="${param.nickname}" placeholder="您希望被如何称呼">
            </div>
            <div class="form-group">
                <label for="ageGroup">年龄段 (可选)</label>
                <select id="ageGroup" name="ageGroup" class="form-control-select"> <%-- 给 select 添加一个class --%>
                    <option value="">— 请选择 —</option>
                    <option value="child" ${param.ageGroup == 'child' ? 'selected' : ''}>儿童 (child)</option>
                    <option value="teenager" ${param.ageGroup == 'teenager' ? 'selected' : ''}>青少年 (teenager)</option>
                    <option value="adult" ${param.ageGroup == 'adult' ? 'selected' : ''}>成人 (adult)</option>
                    <option value="senior" ${param.ageGroup == 'senior' ? 'selected' : ''}>老年人 (senior)</option>
                </select>
            </div>
            <div class="form-group">
                <button type="submit" class="btn-login btn-register">注 册</button> <%-- 复用 btn-login，可以加一个 btn-register 类以便微调颜色 --%>
            </div>
        </form>
        <div class="register-link login-link-alternative"> <%-- 复用 register-link，可以加一个新class --%>
            <p>已有账户? <a href="${pageContext.request.contextPath}/login">立即登录</a></p>
        </div>
    </div>
</div>
</body>
</html>