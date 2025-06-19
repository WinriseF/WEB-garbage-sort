<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑用户 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container { max-width: 800px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #fff; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group select { width: 100%; padding: 8px; border-radius: 4px; border: 1px solid #ccc; }
        .form-group .readonly-input { background-color: #e9ecef; }
        .form-actions button { padding: 10px 20px; border: none; background-color: #007bff; color: white; border-radius: 4px; cursor: pointer; }
        .form-actions button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<div class="form-container">
    <h1>编辑用户: <c:out value="${userToEdit.username}"/></h1>
    <a href="${pageContext.request.contextPath}/admin/users">« 返回用户列表</a>
    <hr style="margin: 20px 0;">

    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">

        <%-- 用于在提交表单时传递用户ID --%>
        <input type="hidden" name="userId" value="${userToEdit.userId}">

        <div class="form-group">
            <label>用户名 (不可修改)</label>
            <input type="text" class="readonly-input" value="<c:out value='${userToEdit.username}'/>" readonly>
        </div>

        <div class="form-group">
            <label for="nickname">昵称</label>
            <input type="text" id="nickname" name="nickname" value="<c:out value='${userToEdit.nickname}'/>">
        </div>

        <div class="form-group">
            <label for="email">邮箱</label>
            <input type="email" id="email" name="email" value="<c:out value='${userToEdit.email}'/>">
        </div>

        <div class="form-group">
            <label for="role">角色</label>
            <select id="role" name="role">
                <option value="user" ${userToEdit.role == 'user' ? 'selected' : ''}>普通用户 (user)</option>
                <option value="editor" ${userToEdit.role == 'editor' ? 'selected' : ''}>编辑 (editor)</option>
                <option value="admin" ${userToEdit.role == 'admin' ? 'selected' : ''}>管理员 (admin)</option>
            </select>
        </div>

        <div class="form-group">
            <label for="isActive">账户状态</label>
            <select id="isActive" name="isActive">
                <option value="true" ${userToEdit.active ? 'selected' : ''}>已激活</option>
                <option value="false" ${!userToEdit.active ? 'selected' : ''}>已禁用</option>
            </select>
        </div>

        <div class="form-actions">
            <button type="submit">保存更改</button>
        </div>
    </form>
</div>
</body>
</html>
