<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>“随手拍”上报管理 - 管理后台</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .admin-container { max-width: 1200px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .content-table { width: 100%; border-collapse: collapse; }
    .content-table th, .content-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
    .status-pending_review { color: orange; font-weight: bold; }
    .status-verified { color: blue; font-weight: bold; }
    .status-resolved { color: green; font-weight: bold; }
    .status-invalid { color: grey; font-weight: bold; }
  </style>
</head>
<body>
<div class="admin-container">
  <div class="admin-header">
    <h1>“随手拍”上报管理</h1>
    <a href="${pageContext.request.contextPath}/admin/dashboard">« 返回仪表盘</a>
  </div>

  <table class="content-table">
    <thead>
    <tr>
      <th>ID</th>
      <th>上报类型</th>
      <th>地址</th>
      <th>上报时间</th>
      <th>状态</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${reportList}" var="report">
      <tr>
        <td>${report.reportId}</td>
        <td><c:out value="${report.reportType}"/></td>
        <td><c:out value="${report.addressText}"/></td>
        <td><fmt:formatDate value="${report.reportedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
        <td><span class="status-${report.status}"><c:out value="${report.status}"/></span></td>
        <td>
          <a href="${pageContext.request.contextPath}/admin/reports/process?id=${report.reportId}">查看与处理</a>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
</body>
</html>
