<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container { max-width: 1200px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .user-table { width: 100%; border-collapse: collapse; }
        .user-table th, .user-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .user-table th { background-color: #f8f9fa; }
        .action-links a { margin-right: 10px; text-decoration: none; }
        .action-links .edit { color: #007bff; }
        .action-links .delete { color: #dc3545; }
    </style>
</head>
<body>
<div class="admin-container">
    <div class="admin-header">
        <h1>用户管理</h1>
        <a href="${pageContext.request.contextPath}/admin/dashboard">« 返回仪表盘</a>
    </div>

    <table class="user-table">
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>昵称</th>
            <th>邮箱</th>
            <th>角色</th>
            <th>状态</th>
            <th>注册日期</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${userList}" var="user">
            <tr>
                <td>${user.userId}</td>
                <td><c:out value="${user.username}"/></td>
                <td><c:out value="${user.nickname}"/></td>
                <td><c:out value="${user.email}"/></td>
                <td>${user.role}</td>
                <td>${user.active ? '已激活' : '已禁用'}</td>
                <td><fmt:formatDate value="${user.registrationDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td class="action-links">
                    <a href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}" class="edit">编辑</a>

                    <a href="${pageContext.request.contextPath}/admin/users/delete?id=${user.userId}" class="delete" onclick="return confirm('警告：确定要永久删除用户“<c:out value="${user.username}"/>”吗？此操作无法撤销！');">删除</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
