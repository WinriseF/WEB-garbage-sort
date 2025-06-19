<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>物品详情 - <c:out value="${itemDetail.mainItem.itemName}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container { max-width: 900px; margin: 30px auto; }
        .item-detail-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        .main-photo { width: 100%; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .item-info h1 { margin-top: 0; }
        .contact-box { background-color: #e9f7ff; border: 1px solid #bce8f1; padding: 20px; border-radius: 8px; margin-top: 20px; }
        .other-items-section { margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; }
        .other-items-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; }
        .other-item-card { background: #fff; border: 1px solid #f0f0f0; border-radius: 8px; text-align: center; }
        .other-item-card img { width: 100%; height: 120px; object-fit: cover; }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/recycling">« 返回市场列表</a>
    <hr>
    <div class="item-detail-grid">
        <!-- 左侧：图片和描述 -->
        <div>
            <img src="${pageContext.request.contextPath}/${itemDetail.mainItem.photoUrls}" class="main-photo" alt="物品照片">
            <h3 style="margin-top:20px;">物品描述</h3>
            <p><c:out value="${itemDetail.mainItem.itemDescription}"/></p>
        </div>
        <!-- 右侧：核心信息 -->
        <div class="item-info">
            <h1><c:out value="${itemDetail.mainItem.itemName}"/></h1>
            <p><b>发布者：</b> <c:out value="${itemDetail.userNickname}"/></p>
            <p><b>发布时间：</b> <fmt:formatDate value="${itemDetail.mainItem.postedAt}" pattern="yyyy-MM-dd"/></p>
            <p><b>想要：</b> <c:out value="${itemDetail.mainItem.wantedItems}"/></p>

            <div class="contact-box">
                <h4>联系方式</h4>
                <p><strong><c:out value="${itemDetail.mainItem.contactInfo}"/></strong></p>
                <small>提示：线下交换或赠送时，请注意人身和财产安全。</small>
            </div>
        </div>
    </div>

    <!-- 该用户发布的其他闲置 -->
    <c:if test="${not empty itemDetail.otherItemsBySameUser}">
        <div class="other-items-section">
            <h2>该用户发布的其他闲置</h2>
            <div class="other-items-grid">
                <c:forEach items="${itemDetail.otherItemsBySameUser}" var="otherItem">
                    <a href="${pageContext.request.contextPath}/recycling/detail?id=${otherItem.itemId}" style="text-decoration:none; color:inherit;">
                        <div class="other-item-card">
                            <img src="${pageContext.request.contextPath}/${otherItem.photoUrls}" alt="其他物品照片">
                            <p style="padding:10px;"><c:out value="${otherItem.itemName}"/></p>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
