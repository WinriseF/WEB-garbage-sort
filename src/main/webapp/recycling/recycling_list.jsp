<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>旧物利用 - 跳蚤市场</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans SC', sans-serif; background-color: #f4f7f6; }
        .container { max-width: 1200px; margin: 20px auto; padding: 20px; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid #e0e0e0; }
        .header-bar h1 { font-size: 28px; font-weight: 700; margin: 0; }
        .header-actions { display: flex; align-items: center; gap: 15px; }
        .header-actions a { padding: 10px 20px; text-decoration: none; border-radius: 8px; font-weight: 500; transition: all 0.2s ease; }
        .post-button { background-color: #28a745; color: white; }
        .my-items-button { background-color: #007bff; color: white; }
        .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; }
        .item-card { background: #fff; border: 1px solid #e9ecef; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; }
        .item-card-link { text-decoration: none; color: inherit; }
        .item-card img { width: 100%; height: 220px; object-fit: cover; background-color: #f8f9fa; }
        .card-content { padding: 20px; flex-grow: 1; display: flex; flex-direction: column; }
        .card-content h3 { margin-top: 0; margin-bottom: 10px; font-size: 1.2em; }
        .card-content p { margin: 0 0 15px 0; color: #6c757d; flex-grow: 1; }
        .detail-link { display: block; text-align: center; padding: 10px; background-color: #f8f9fa; color: #333; text-decoration: none; border-top: 1px solid #eee; margin-top: auto; }
        .empty-state { text-align: center; color: #888; padding: 50px; background-color: #fff; border-radius: 12px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header-bar">
        <h1>旧物利用市场</h1>
        <div class="header-actions">
            <c:if test="${not empty sessionScope.loggedInUser}">
                <a href="${pageContext.request.contextPath}/recycling/my-items" class="my-items-button">我的发布</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/recycling/post" class="post-button">+ 发布我的闲置</a>
        </div>
    </div>

    <div class="item-grid">
        <%-- 【关键】: JSTL的<c:forEach>会遍历Servlet传来的itemList --%>
        <c:forEach items="${itemList}" var="item">
            <div class="item-card">
                <a href="${pageContext.request.contextPath}/recycling/detail?id=${item.itemId}" class="item-card-link">
                    <c:choose>
                        <c:when test="${not empty item.photoUrls}">
                            <img src="${pageContext.request.contextPath}/${item.photoUrls}" alt="<c:out value='${item.itemName}'/>">
                        </c:when>
                        <c:otherwise>
                            <img src="https://placehold.co/400x300/EFEFEF/AAAAAA?text=无图片" alt="[物品图片]">
                        </c:otherwise>
                    </c:choose>
                    <div class="card-content">
                        <h3><c:out value="${item.itemName}"/></h3>
                        <p><b>想要:</b> <c:out value="${item.wantedItems}"/></p>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <%-- 【关键】: 如果itemList为空，<c:if>会显示下面的提示信息 --%>
    <c:if test="${empty itemList}">
        <div class="empty-state">
            <p>当前还没有人发布闲置物品，快来成为第一个吧！</p>
        </div>
    </c:if>

</div>
</body>
</html>
