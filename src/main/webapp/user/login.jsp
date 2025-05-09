<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户登录 - 智能垃圾分类教育平台</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { width: 350px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"] {
            width: 95%; padding: 8px; margin-bottom: 10px; border: 1px solid #ddd; border-radius: 3px;
        }
        input[type="submit"] { padding: 10px 15px; background-color: #007bff; color: white; border: none; border-radius: 3px; cursor: pointer; }
        input[type="submit"]:hover { background-color: #0056b3; }
        .error { color: red; font-size: 0.9em; margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>用户登录</h2>

    <c:if test="${not empty requestScope.errorMessage}">
        <p class="error">${requestScope.errorMessage}</p>
    </c:if>
    <c:if test="${not empty param.logout}">
        <p style="color:green;">您已成功注销。</p>
    </c:if>
    <c:if test="${not empty param.registered}">
        <p style="color:green;">注册成功！请登录。</p>
    </c:if>


    <form action="${pageContext.request.contextPath}/login" method="post">
        <div>
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" value="${param.username}" required>
        </div>
        <div>
            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div>
            <input type="submit" value="登录">
        </div>
    </form>
    <p>还没有账户? <a href="${pageContext.request.contextPath}/register">立即注册</a></p>
</div>
</body>
</html>