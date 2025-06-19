<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的发布 - 旧物利用</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 960px; margin: 30px auto; padding: 20px; }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .item-list { list-style: none; padding: 0; }
        .item-entry { display: flex; align-items: center; background: #fff; border: 1px solid #eee; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .item-entry img { width: 100px; height: 100px; object-fit: cover; border-radius: 6px; margin-right: 20px; }
        .item-info { flex-grow: 1; }
        .item-info h3 { margin: 0 0 10px 0; }
        .item-actions a { text-decoration: none; padding: 8px 18px; border-radius: 5px; text-align: center; color: white; }
        .btn-delete { background-color: #dc3545; }
        .btn-post { background-color: #28a745; text-decoration: none; padding: 10px 20px; color: white; border-radius: 8px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header-bar">
        <h1>我的发布</h1>
        <div>
            <%-- 【关键修改】: “继续发布”的统一入口 --%>
            <a href="${pageContext.request.contextPath}/recycling/post" class="btn-post">+ 继续发布</a>
            <a href="${pageContext.request.contextPath}/recycling" style="margin-left: 15px;">« 返回市场</a>
        </div>
    </div>

    <div class="item-list">
        <c:forEach items="${myItemsList}" var="item">
            <div class="item-entry">
                <img src="${pageContext.request.contextPath}/${item.photoUrls}" onerror="this.src='https://placehold.co/200x200/EFEFEF/AAAAAA?text=无图片'">
                <div class="item-info">
                    <h3><c:out value="${item.itemName}"/></h3>
                    <p><b>状态:</b>
                        <span style="color: ${item.status == 'available' ? 'green' : 'grey'}; font-weight: bold;">
                                ${item.status == 'available' ? '可交换' : '已换出'}
                        </span>
                    </p>
                    <p><b>发布于:</b> <fmt:formatDate value="${item.postedAt}" pattern="yyyy-MM-dd"/></p>
                </div>
                <div class="item-actions">
                        <%-- 【关键修改】: 移除了编辑按钮，只保留删除 --%>
                    <a href="${pageContext.request.contextPath}/recycling/delete?id=${item.itemId}" class="btn-delete"
                       onclick="return confirm('您确定要删除“<c:out value="${item.itemName}"/>”吗？此操作无法撤销。');">删除</a>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty myItemsList}">
            <p>您还没有发布过任何闲置物品。</p>
        </c:if>
    </div>
</div>
</body>
</html>
