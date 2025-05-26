<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 智能垃圾分类教育平台</title>
    <%-- 引用与登录页面相同的CSS文件，或者一个包含共同样式的CSS文件 --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cropper.min.css">
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

        <form id="registrationForm" action="${pageContext.request.contextPath}/register" method="post" class="login-form" enctype="multipart/form-data">
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
                <label for="avatarFileInput">选择头像 (可选):</label>
                <input type="file" id="avatarFileInput" name="avatarFileOriginal" accept="image/png, image/jpeg, image/gif">
                <img id="avatarPreviewCropped" src="#" alt="裁剪后预览"/>
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

<div id="cropperModalContainer" class="cropper-modal-container">
    <div class="cropper-content">
        <h3>裁剪头像</h3>
        <div class="cropper-image-container">
            <img id="imageToCrop" src="#" alt="待裁剪图片">
        </div>
        <div class="cropper-buttons">
            <button type="button" id="confirmCropButton" class="btn-primary">确认裁剪</button>
            <button type="button" id="cancelCropButton" class="btn-secondary">取消</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/css/cropper.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const avatarFileInput = document.getElementById('avatarFileInput');
        const imageToCropElement = document.getElementById('imageToCrop');
        const cropperModalContainer = document.getElementById('cropperModalContainer');
        const confirmCropButton = document.getElementById('confirmCropButton');
        const cancelCropButton = document.getElementById('cancelCropButton');
        const registrationForm = document.getElementById('registrationForm'); // 获取表单
        const avatarPreviewCropped = document.getElementById('avatarPreviewCropped');

        let cropperInstance = null;
        let originalFileDetails = null;
        let croppedImageBlob = null;

        // 监听文件选择框的 change 事件
        avatarFileInput.addEventListener('change', function(event) {
            const files = event.target.files;
            if (files && files.length > 0) {
                const file = files[0];
                // 简单文件类型校验
                if (!file.type.startsWith('image/')) {
                    alert('请选择图片文件！');
                    avatarFileInput.value = ''; // 清空选择
                    return;
                }
                originalFileDetails = { name: file.name, type: file.type };

                const reader = new FileReader();
                reader.onload = function(e) {
                    imageToCropElement.src = e.target.result;
                    cropperModalContainer.style.display = 'flex'; // 显示模态框

                    if (cropperInstance) {
                        cropperInstance.destroy();
                    }
                    cropperInstance = new Cropper(imageToCropElement, {
                        aspectRatio: 1 / 1, // 正方形裁剪
                        viewMode: 1,
                        dragMode: 'move',
                        background: false,
                        autoCropArea: 0.8,
                        responsive: true,
                        guides: true, // 显示辅助线
                        center: true,
                        highlight: true,
                        cropBoxMovable: true,
                        cropBoxResizable: true,
                        minCropBoxWidth: 100, // 最小裁剪框宽度
                        minCropBoxHeight: 100 // 最小裁剪框高度
                    });
                };
                reader.readAsDataURL(file);
                // 清空文件输入框的值，这样用户下次选择相同文件也能触发 change 事件
                avatarFileInput.value = '';
            }
        });

        // 取消裁剪按钮事件
        cancelCropButton.addEventListener('click', function() {
            cropperModalContainer.style.display = 'none';
            if (cropperInstance) {
                cropperInstance.destroy();
                cropperInstance = null;
            }
            croppedImageBlob = null;
            avatarPreviewCropped.style.display = 'none';
        });

        // 确认裁剪按钮事件
        confirmCropButton.addEventListener('click', function() {
            if (cropperInstance) {
                const canvas = cropperInstance.getCroppedCanvas({
                    width: 256, // 输出宽度
                    height: 256, // 输出高度
                    imageSmoothingEnabled: true,
                    imageSmoothingQuality: 'medium'
                });
                canvas.toBlob(function(blob) {
                    croppedImageBlob = blob; // 保存裁剪后的Blob
                    avatarPreviewCropped.src = canvas.toDataURL(originalFileDetails.type);
                    avatarPreviewCropped.style.display = 'block'; // 显示裁剪后的小预览图

                    cropperModalContainer.style.display = 'none'; // 关闭模态框
                    if (cropperInstance) {
                        cropperInstance.destroy();
                        cropperInstance = null;
                    }
                }, originalFileDetails.type); // 使用原始图片类型，或指定 'image/jpeg' 或 'image/png'
            }
        });

        // 表单提交事件监听
        registrationForm.addEventListener('submit', function(event) {
            if (croppedImageBlob) {
                event.preventDefault(); // 阻止表单的默认提交行为

                const formData = new FormData(registrationForm); // 获取表单中的其他数据

                // 移除可能存在的原始文件输入（如果name不是我们期望的）
                // 如果你的 input name="avatarFileOriginal" 只是用来触发，不应提交，可以不加，
                // 但如果与 servlet 期望的 name 冲突，则要处理。
                // formData.delete('avatarFileOriginal');

                // 将裁剪后的Blob数据添加到FormData中，字段名设置为 'avatarFile'
                // 这是后端 RegisterServlet 中 request.getPart("avatarFile") 所期望的名称
                let fileName = "cropped_avatar.png"; // 默认文件名和类型
                if (originalFileDetails && originalFileDetails.name) {
                    const nameParts = originalFileDetails.name.split('.');
                    const extension = nameParts.length > 1 ? nameParts.pop() : 'png';
                    fileName = nameParts.join('.') + "_cropped." + extension;
                }
                formData.append('avatarFile', croppedImageBlob, fileName);

                // 使用 Fetch API 异步提交表单数据
                fetch(registrationForm.action, {
                    method: 'POST',
                    body: formData
                    // 对于 FormData，浏览器通常会自动设置正确的 Content-Type header (multipart/form-data; boundary=...)
                })
                    .then(response => {
                        // 根据Servlet的响应方式进行处理
                        if (response.ok) {
                            if (response.redirected) { // 如果Servlet执行了response.sendRedirect()
                                window.location.href = response.url;
                            } else {
                                // 如果Servlet执行了forward()，或直接写入了响应体 (例如返回错误信息页面)
                                return response.text().then(html => {
                                    // 这是一个简化处理，实际中可能需要更复杂的逻辑来更新页面部分或显示消息
                                    if (response.url.includes("login.jsp?registered=true")) { // 检查是否是成功重定向的URL（虽然上面已经有redirected判断）
                                        window.location.href = response.url;
                                    } else {
                                        // 尝试将返回的HTML（可能是错误页面）直接显示在当前页面，这可能破坏布局
                                        // 更好的方式是让Servlet返回JSON，然后JS根据JSON内容更新页面的特定部分或显示弹窗
                                        console.warn("表单提交后，服务器未重定向，收到的响应体：", html.substring(0, 500) + "...");
                                        document.open();
                                        document.write(html); // 非常粗暴地替换整个页面内容
                                        document.close();
                                        // 或者，你可以尝试解析html中的错误信息，显示在页面的某个div中
                                        // const errorDiv = document.querySelector('.message.error-message p');
                                        // if(errorDiv && html.includes("errorMessage")) { /* ...解析并显示... */ }
                                    }
                                });
                            }
                        } else {
                            // HTTP错误状态 (例如 400, 500)
                            console.error('服务器错误:', response.status, response.statusText);
                            return response.text().then(errorHtml => {
                                alert('注册请求失败，服务器返回错误。请查看控制台。');
                                console.error("错误详情:", errorHtml);
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Fetch API 提交表单错误:', error);
                        alert('网络错误或表单提交过程中发生未知错误。');
                    });
            }
            // 如果 croppedImageBlob 为 null (用户没有选择或没有裁剪头像)，则表单会以传统方式提交
            // 这时，如果 avatarFileInput (id="avatarFileInput") 的 name 属性是 "avatarFile"，
            // 那么它会提交原始文件（如果用户选择了的话）。
            // 在当前设置中，avatarFileInput 的 name 是 "avatarFileOriginal"，所以它本身不会被提交为期望的 "avatarFile"
            // 如果希望在不裁剪时也提交原始文件，需要确保 input 的 name="avatarFile"
        });

        var captchaImage = document.getElementById('captchaImage');
        if (captchaImage) {
            captchaImage.addEventListener('click', function() {
                this.src = '${pageContext.request.contextPath}/captchaImage?r=' + Math.random();
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