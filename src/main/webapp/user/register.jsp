<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户注册 - 智能垃圾分类教育平台</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 400px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"], input[type="email"], select {
            width: 95%; padding: 8px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 3px;
        }
        input[type="submit"] { padding: 10px 15px; background-color: #5cb85c; color: white; border: none; border-radius: 3px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #4cae4c; }
        .error { color: red; font-size: 0.9em; margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>用户注册</h2>

    <c:if test="${not empty requestScope.errorMessage}">
        <p class="error">${requestScope.errorMessage}</p>
    </c:if>
    <c:if test="${not empty requestScope.successMessage}">
        <p style="color:green;">${requestScope.successMessage}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div>
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" value="${param.username}" required>
        </div>
        <div>
            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <label for="confirmPassword">确认密码:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <div>
            <label for="email">邮箱:</label>
            <input type="email" id="email" name="email" value="${param.email}"> <%-- 邮箱可为空 --%>
        </div>
        <div>
            <label for="nickname">昵称:</label>
            <input type="text" id="nickname" name="nickname" value="${param.nickname}">
        </div>
        <div>
            <label for="ageGroup">年龄段:</label>
            <select id="ageGroup" name="ageGroup">
                <option value="">请选择</option>
                <option value="child" ${param.ageGroup == 'child' ? 'selected' : ''}>儿童 (child)</option>
                <option value="teenager" ${param.ageGroup == 'teenager' ? 'selected' : ''}>青少年 (teenager)</option>
                <option value="adult" ${param.ageGroup == 'adult' ? 'selected' : ''}>成人 (adult)</option>
                <option value="senior" ${param.ageGroup == 'senior' ? 'selected' : ''}>老年人 (senior)</option>
            </select>
        </div>
        <div>
            <input type="submit" value="注册">
        </div>
    </form>
    <p>已有账户? <a href="${pageContext.request.contextPath}/login">立即登录</a></p>
</div>
</body>
</html>