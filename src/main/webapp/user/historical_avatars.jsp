<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>历史头像 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        .container { max-width: 900px; margin: 20px auto; padding: 20px; background-color: white; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .historical-avatars-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px; /* 头像之间的间距 */
            justify-content: center; /* 居中显示头像项 */
            margin-top: 20px;
        }
        .avatar-item {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            text-align: center;
            width: calc(33.333% - 40px); /* 大致三列，需要根据gap调整 */
            min-width: 200px; /* 最小宽度 */
            box-sizing: border-box;
        }
        .avatar-item img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%; /* 圆形历史头像 */
            margin-bottom: 10px;
            border: 2px solid #eee;
        }
        .avatar-item p {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .btn-download {
            display: inline-block;
            padding: 8px 15px;
            background-color: #28a745;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.9em;
        }
        .no-history {
            text-align: center;
            padding: 20px;
            color: #777;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>我的历史头像</h2>
    <c:set var="paths" value="${requestScope.historicalAvatars}"/>

    <c:if test="${empty paths.avatar1 && empty paths.avatar2 && empty paths.avatar3}">
        <p class="no-history">您当前没有历史头像记录。</p>
    </c:if>

    <div class="historical-avatars-grid">
        <c:if test="${not empty paths.avatar1}">
            <div class="avatar-item">
                <p>历史头像 1 (最新)</p>
                <img src="${pageContext.request.contextPath}/${paths.avatar1}" alt="历史头像 1">
                <br>
                <a href="${pageContext.request.contextPath}/downloadAvatar?path=${paths.avatar1}" class="btn-download">下载此头像</a>
            </div>
        </c:if>
        <c:if test="${not empty paths.avatar2}">
            <div class="avatar-item">
                <p>历史头像 2</p>
                <img src="${pageContext.request.contextPath}/${paths.avatar2}" alt="历史头像 2">
                <br>
                <a href="${pageContext.request.contextPath}/downloadAvatar?path=${paths.avatar2}" class="btn-download">下载此头像</a>
            </div>
        </c:if>
        <c:if test="${not empty paths.avatar3}">
            <div class="avatar-item">
                <p>历史头像 3 (最旧)</p>
                <img src="${pageContext.request.contextPath}/${paths.avatar3}" alt="历史头像 3">
                <br>
                <a href="${pageContext.request.contextPath}/downloadAvatar?path=${paths.avatar3}" class="btn-download">下载此头像</a>
            </div>
        </c:if>
    </div>

    <div style="text-align: center; margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/user/profile.jsp" class="btn">返回个人资料</a>
    </div>
</div>
</body>
</html>