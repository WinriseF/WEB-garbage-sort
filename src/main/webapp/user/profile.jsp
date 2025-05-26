<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人资料 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .profile-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 20px auto;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-avatar-large {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #eee;
            margin-bottom: 15px;
        }
        .profile-details table {
            width: 100%;
            border-collapse: collapse;
        }
        .profile-details th, .profile-details td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
        }
        .profile-details th {
            width: 120px; /* 标签宽度 */
            color: #555;
        }
        .profile-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .profile-actions h3 {
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="file"] {
            display: block;
            margin-bottom:10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #007bff;
            color: white;
            text-decoration: none; /* 如果是链接 */
            display: inline-block; /* 如果是链接 */
            margin-top:10px;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; } /* 确保有基础样式 */
        .profile-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 20px auto;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-avatar-large {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #eee;
            margin-bottom: 15px;
        }
        .profile-details table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px; /* 给表格和下面的动作区一点间距 */
        }
        .profile-details th, .profile-details td {
            padding: 12px;
            border-bottom: 1px solid #f0f0f0;
            text-align: left;
            vertical-align: top; /* 确保内容较多时标签和值顶部对齐 */
        }
        .profile-details th {
            width: 120px;
            color: #555;
            font-weight: bold;
        }
        .profile-actions {
            margin-top: 20px; /* 与上一个元素的间距 */
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .profile-actions:first-child { /* 第一个动作区不需要上边框和上内边距 */
            border-top: none;
            padding-top: 0;
        }
        .profile-actions h3 {
            margin-top: 0; /* 移除h3的上外边距，因为profile-actions已有 */
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="file"] {
            display: block;
            margin-bottom:10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            text-align: center;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-secondary {
            background-color: #007bff;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .success-message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error-message { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.loggedInUser}">
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<div class="profile-container">
    <div class="profile-header">
        <h2>个人资料</h2>
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser.currentAvatarPath}">
                <img src="${pageContext.request.contextPath}/${sessionScope.loggedInUser.currentAvatarPath}" alt="用户头像" class="profile-avatar-large">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/images/default_avatar.png" alt="默认头像" class="profile-avatar-large">
            </c:otherwise>
        </c:choose>
        <h3><c:out value="${sessionScope.loggedInUser.nickname != null ? sessionScope.loggedInUser.nickname : sessionScope.loggedInUser.username}"/></h3>
    </div>

    <c:if test="${not empty requestScope.successMessage}">
        <div class="message success-message">${requestScope.successMessage}</div>
    </c:if>
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="message error-message">${requestScope.errorMessage}</div>
    </c:if>

    <div class="profile-details">
        <table>
            <tr>
                <th>用户ID:</th>
                <td><c:out value="${sessionScope.loggedInUser.userId}"/></td>
            </tr>
            <tr>
                <th>用户名:</th>
                <td><c:out value="${sessionScope.loggedInUser.username}"/></td>
            </tr>
            <c:if test="${not empty sessionScope.loggedInUser.nickname}">
                <tr>
                    <th>昵称:</th>
                    <td><c:out value="${sessionScope.loggedInUser.nickname}"/></td>
                </tr>
            </c:if>
            <c:if test="${not empty sessionScope.loggedInUser.email}">
                <tr>
                    <th>邮箱:</th>
                    <td><c:out value="${sessionScope.loggedInUser.email}"/></td>
                </tr>
            </c:if>
            <c:if test="${not empty sessionScope.loggedInUser.ageGroup}">
                <tr>
                    <th>年龄段:</th>
                    <td><c:out value="${sessionScope.loggedInUser.ageGroup}"/></td>
                </tr>
            </c:if>
            <tr>
                <th>角色:</th>
                <td><c:out value="${sessionScope.loggedInUser.role}"/></td>
            </tr>
            <tr>
                <th>账户状态:</th>
                <td>${sessionScope.loggedInUser.active ? "已激活" : "未激活"}</td>
            </tr>
            <tr>
                <th>注册日期:</th>
                <td><fmt:formatDate value="${sessionScope.loggedInUser.registrationDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
            <c:if test="${not empty sessionScope.loggedInUser.lastLoginDate}">
                <tr>
                    <th>上次登录:</th>
                    <td><fmt:formatDate value="${sessionScope.loggedInUser.lastLoginDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
            </c:if>
        </table>
    </div>

    <div class="profile-actions">
        <h3>更换头像</h3>
        <form action="${pageContext.request.contextPath}/updateAvatar" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="newAvatarFile">选择新头像:</label>
                <input type="file" id="newAvatarFile" name="newAvatarFile" accept="image/png, image/jpeg, image/gif" required>
            </div>
            <button type="submit" class="btn btn-primary">上传并更新头像</button>
        </form>
    </div>

    <div class="profile-actions">
        <h3>历史头像</h3>
        <a href="${pageContext.request.contextPath}/viewHistoricalAvatars" class="btn btn-secondary">查看我的历史头像</a>
    </div>
    <div style="text-align: center; margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn">返回首页</a>
    </div>
</div>
</body>
</html>