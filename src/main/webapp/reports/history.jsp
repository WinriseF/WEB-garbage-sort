<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <title>我的提交历史 - 随手拍</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .container { max-width: 900px; margin: 20px auto; padding: 20px; }
    .history-item { display: flex; align-items: center; background: #fff; border: 1px solid #e9ecef; border-radius: 8px; margin-bottom: 15px; padding: 15px; }
    .history-item img { width: 100px; height: 100px; object-fit: cover; border-radius: 4px; margin-right: 20px; }
    .history-info p { margin: 5px 0; }
    .status-pending_review { color: orange; }
    .status-verified { color: blue; }
    .status-resolved { color: green; }
    .status-invalid { color: grey; }
  </style>
</head>
<body>
<div class="container">
  <h1>我的提交历史</h1>
  <p><a href="${pageContext.request.contextPath}/reports/report_form.jsp">« 继续上报</a> | <a href="${pageContext.request.contextPath}/reports/feed">查看问题广场</a></p>
  <hr>

  <c:forEach items="${historyList}" var="item">
    <div class="history-item">
      <c:if test="${not empty item.photoUrls}">
        <img src="${pageContext.request.contextPath}/${item.photoUrls}" alt="现场照片">
      </c:if>
      <div class="history-info">
        <p><strong>地址：</strong><c:out value="${item.addressText}"/></p>
        <p><strong>状态：</strong><b class="status-${item.status}"><c:out value="${item.status}"/></b></p>
        <p style="font-size:0.8em; color:#999;">提交于: <fmt:formatDate value="${item.reportedAt}" pattern="yyyy-MM-dd HH:mm"/></p>
      </div>
    </div>
  </c:forEach>
  <c:if test="${empty historyList}">
    <p>您还没有提交过任何上报记录，快去发现并上报吧！</p>
  </c:if>
</div>
</body>
</html>
