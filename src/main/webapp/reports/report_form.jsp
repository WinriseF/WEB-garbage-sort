<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>随手拍 - 上报环境问题</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Noto Sans SC', sans-serif;
        }

        .form-wrapper {
            max-width: 700px;
            margin: 40px auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
            position: relative; /* 为了右上角导航的定位 */
        }

        /* 【关键修改】: 右上角导航链接的样式 */
        .header-nav {
            position: absolute;
            top: 25px;
            right: 35px;
            display: flex;
            gap: 20px; /* 链接之间的间距 */
        }
        .header-nav a {
            text-decoration: none;
            color: #6c757d;
            font-weight: 500;
            font-size: 15px;
            transition: color 0.2s;
        }
        .header-nav a:hover {
            color: #007bff;
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .form-header .icon {
            width: 32px;
            height: 32px;
            margin-right: 12px;
        }
        .form-header p {
            color: #6c757d;
            font-size: 16px;
        }

        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #495057;
        }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #ced4da;
            box-sizing: border-box;
            font-size: 16px;
        }

        /* 其他表单元素样式... */

    </style>
</head>
<body>

<div class="form-wrapper">
    <!-- 【关键修改】: 在这里添加了包含“返回主页”的导航链接 -->
    <div class="header-nav">
        <a href="${pageContext.request.contextPath}/">返回主页</a>
        <a href="${pageContext.request.contextPath}/reports/feed">问题广场</a>
        <c:if test="${not empty sessionScope.loggedInUser}">
            <a href="${pageContext.request.contextPath}/reports/history">我的提交</a>
        </c:if>
    </div>

    <div class="form-header">
        <h1>
            <img src="https://img.icons8.com/plasticine/100/null/camera.png" alt="[相机图标]" class="icon"/>
            随手拍
        </h1>
        <p>感谢您的参与，共同守护我们的家园！</p>
    </div>

    <form action="${pageContext.request.contextPath}/reports/submit" method="post" enctype="multipart/form-data">

        <%-- 表单的具体内容保持不变 --%>
        <div class="form-group">
            <label for="reportType">问题类型 (*)</label>
            <select id="reportType" name="reportType" required>
                <option value="improper_sorting">垃圾分类不当</option>
                <option value="littering">垃圾乱丢</option>
                <option value="facility_damage">公共设施损坏</option>
                <option value="pollution_incident">污染事件</option>
                <option value="other">其他问题</option>
            </select>
        </div>
        <div class="form-group">
            <label for="description">问题描述 (*)</label>
            <textarea id="description" name="description" required placeholder="请详细描述您看到的情况..."></textarea>
        </div>
        <div class="form-group">
            <label for="addressText">问题地址 (*)</label>
            <input type="text" id="addressText" name="addressText" required placeholder="例如：XX小区XX栋楼下垃圾桶旁">
        </div>
        <div class="form-group">
            <label for="photo">上传照片 (证据)</label>
            <input type="file" id="photo" name="photo" accept="image/*">
        </div>

        <div class="form-actions">
            <button type="submit" style="width:100%; padding:15px; font-size: 18px;">确认提交</button>
        </div>
    </form>
</div>

</body>
</html>
