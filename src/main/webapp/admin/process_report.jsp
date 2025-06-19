<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>处理上报 - 管理后台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .detail-container { display: flex; max-width: 1200px; margin: 20px auto; gap: 30px; }
        .report-info { flex: 2; }
        .report-actions { flex: 1; background-color: #f8f9fa; padding: 20px; border-radius: 8px; }
        .info-block { margin-bottom: 20px; }
        .info-block h3 { border-bottom: 1px solid #eee; padding-bottom: 5px; }
        .report-photo { max-width: 100%; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2); }
    </style>
</head>
<body>
<div style="max-width: 1200px; margin: 20px auto;">
    <a href="${pageContext.request.contextPath}/admin/reports/manage">« 返回上报列表</a>
</div>
<div class="detail-container">
    <div class="report-info">
        <h2>上报详情 (ID: ${report.reportId})</h2>
        <div class="info-block">
            <h3>问题照片</h3>
            <c:if test="${not empty report.photoUrls}">
                <img src="${pageContext.request.contextPath}/${report.photoUrls}" alt="上报的照片" class="report-photo">
            </c:if>
            <c:if test="${empty report.photoUrls}">
                <p>用户未上传照片。</p>
            </c:if>
        </div>
        <div class="info-block">
            <h3>问题描述</h3>
            <p><c:out value="${report.description}"/></p>
        </div>
        <div class="info-block">
            <h3>上报地址</h3>
            <p><c:out value="${report.addressText}"/></p>
        </div>
    </div>
    <div class="report-actions">
        <h3>处理此上报</h3>
        <form action="${pageContext.request.contextPath}/admin/reports/process" method="post">
            <input type="hidden" name="reportId" value="${report.reportId}">
            <div class="form-group">
                <label for="status">更新状态</label>
                <select id="status" name="status" class="form-control" style="width:100%; padding: 8px;">
                    <option value="pending_review" ${report.status == 'pending_review' ? 'selected' : ''}>待审核</option>
                    <option value="verified" ${report.status == 'verified' ? 'selected' : ''}>已核实</option>
                    <option value="resolved" ${report.status == 'resolved' ? 'selected' : ''}>已解决</option>
                    <option value="invalid" ${report.status == 'invalid' ? 'selected' : ''}>无效上报</option>
                </select>
            </div>
            <div class="form-group">
                <label for="adminNotes">处理备注 (可选)</label>
                <textarea id="adminNotes" name="adminNotes" class="form-control" style="width:100%; min-height:100px; padding: 8px;"><c:out value="${report.adminNotes}"/></textarea>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; padding: 10px;">保存更新</button>
        </form>
    </div>
</div>
</body>
</html>
