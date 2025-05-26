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
<div class="login-wrapper">
    <div class="login-container register-container">
        <div class="login-header">
            <h2>创建您的账户</h2>
            <p>加入我们，一起学习垃圾分类！</p>
        </div>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="message error-message">
                <p>${requestScope.errorMessage}</p>
            </div>
        </c:if>
        <c:if test="${not empty requestScope.successMessage}">
            <div class="message success-message">
                <p>${requestScope.successMessage}</p>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" class="login-form" enctype="multipart/form-data">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" value="<c:out value='${not empty requestScope.username ? requestScope.username : param.username}'/>" placeholder="3-50位字符" required>
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
                <input type="email" id="email" name="email" value="<c:out value='${not empty requestScope.email ? requestScope.email : param.email}'/>" placeholder="例如: user@example.com">
            </div>
            <div class="form-group">
                <label for="nickname">昵称 (可选)</label>
                <input type="text" id="nickname" name="nickname" value="<c:out value='${not empty requestScope.nickname ? requestScope.nickname : param.nickname}'/>" placeholder="您希望被如何称呼">
            </div>
            <div class="form-group form-group-avatar">
                <label for="avatarFile">选择头像 (可选)</label>
                <input type="file" id="avatarFile" name="avatarFile" accept="image/png, image/jpeg, image/gif">
                <img id="avatarPreview" src="#" alt="头像预览" />
            </div>
            <div class="form-group">
                <label for="ageGroup">年龄段 (可选)</label>
                <select id="ageGroup" name="ageGroup" class="form-control-select">
                    <c:set var="selectedAgeGroup" value="${not empty requestScope.ageGroup ? requestScope.ageGroup : param.ageGroup}" />
                    <option value="" ${empty selectedAgeGroup ? 'selected' : ''}>— 请选择 —</option>
                    <option value="child" ${selectedAgeGroup == 'child' ? 'selected' : ''}>儿童</option>
                    <option value="teenager" ${selectedAgeGroup == 'teenager' ? 'selected' : ''}>青少年</option>
                    <option value="adult" ${selectedAgeGroup == 'adult' ? 'selected' : ''}>成人</option>
                    <option value="senior" ${selectedAgeGroup == 'senior' ? 'selected' : ''}>老年人</option>
                </select>
            </div>
            <div class="form-group">
                <label for="captcha">验证码</label>
                <div class="captcha-row">
                    <input type="text" id="captcha" name="captcha" placeholder="结果" required autocomplete="off">
                    <img id="captchaImage" src="${pageContext.request.contextPath}/captchaImage" alt="验证码图片" title="点击刷新验证码">
                </div>
            </div>
            <div class="form-group">
                <button type="submit" class="btn-login btn-register">注 册</button>
            </div>
        </form>
        <div class="register-link login-link-alternative">
            <p>已有账户? <a href="${pageContext.request.contextPath}/login">立即登录</a></p>
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

        var avatarFileInput = document.getElementById('avatarFile');
        var avatarPreview = document.getElementById('avatarPreview');
        if (avatarFileInput && avatarPreview) {
            avatarFileInput.addEventListener('change', function(event) {
                var file = event.target.files[0];
                if (file && file.type.startsWith('image/')) { // 确保是图片文件
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        avatarPreview.src = e.target.result;
                        avatarPreview.style.display = 'block'; // 显示预览图片
                    }
                    reader.readAsDataURL(file);
                } else {
                    avatarPreview.src = '#'; // 清除预览
                    avatarPreview.style.display = 'none'; // 隐藏预览图片
                }
            });
        }

        //注册失败后自动聚焦逻辑
        <c:if test="${not empty requestScope.errorMessage}">
        var captchaInput = document.getElementById('captcha');
        var usernameInput = document.getElementById('username');
        var passwordInput = document.getElementById('password');
        var confirmPasswordInput = document.getElementById('confirmPassword');
        var emailInput = document.getElementById('email');

        var errorMessageText = "<c:out value='${requestScope.errorMessage}'/>".toLowerCase(); // 转小写方便匹配

        if (errorMessageText.includes("验证码")) {
            if (captchaInput) captchaInput.focus();
        } else if (errorMessageText.includes("用户名")) {
            if (usernameInput) usernameInput.focus();
        } else if (errorMessageText.includes("两次输入的密码不一致")) {
            if (confirmPasswordInput) confirmPasswordInput.focus();
        } else if (errorMessageText.includes("密码")) { // 如果不是上面的不一致，那就是密码本身的问题
            if (passwordInput) passwordInput.focus();
        } else if (errorMessageText.includes("邮箱")) {
            if (emailInput) emailInput.focus();
        } else {
            // 默认聚焦用户名
            if (usernameInput) usernameInput.focus();
        }
        </c:if>
    });
</script>
</body>
</html>