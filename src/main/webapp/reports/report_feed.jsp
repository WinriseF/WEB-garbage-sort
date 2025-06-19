<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>问题广场 - 随手拍</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
            font-family: 'Noto Sans SC', sans-serif;
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }

        /* 【新增】包裹按钮的容器 */
        .header-actions {
            display: flex;
            align-items: center;
            gap: 15px; /* 按钮之间的间距 */
        }

        .header-actions a {
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: background-color 0.2s, transform 0.2s;
            display: inline-block;
        }

        .header-actions .report-button {
            background-color: #007bff;
            color: white;
        }
        .header-actions .report-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }

        /* 【新增】返回主页按钮的样式 */
        .header-actions .home-button {
            background-color: #6c757d;
            color: white;
        }
        .header-actions .home-button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .report-card {
            background: #ffffff;
            border-radius: 12px;
            margin-bottom: 25px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: box-shadow 0.3s ease;
        }
        .report-card:hover {
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        .report-card img {
            width: 100%;
            max-height: 450px;
            object-fit: cover;
            border-bottom: 1px solid #eee;
        }

        .report-info {
            padding: 20px 25px;
        }

        .info-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .info-header .address {
            font-size: 18px;
            font-weight: 500;
            color: #333;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 500;
            color: #fff;
        }
        .status-verified { background-color: #17a2b8; } /* 已核实 - 青色 */
        .status-resolved { background-color: #28a745; } /* 已解决 - 绿色 */

        .info-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 14px;
            color: #868e96;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #f0f2f5;
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            background: #fff;
            border-radius: 12px;
        }
        .empty-state h3 {
            font-size: 22px;
            color: #555;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1>问题广场</h1>
        <%-- 【关键修改】: 将两个按钮放入一个容器中，并添加返回主页按钮 --%>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/" class="home-button">返回主页</a>
            <a href="${pageContext.request.contextPath}/reports/report_form.jsp" class="report-button">+ 我要上报</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty reportList}">
            <c:forEach items="${reportList}" var="report">
                <div class="report-card">
                    <c:if test="${not empty report.photoUrls}">
                        <img src="${pageContext.request.contextPath}/${report.photoUrls}" alt="现场照片"
                             onerror="this.style.display='none'">
                    </c:if>
                    <div class="report-info">
                        <div class="info-header">
                            <span class="address"><c:out value="${report.addressText}"/></span>
                            <span class="status-badge status-${report.status}"><c:out value="${report.status}"/></span>
                        </div>
                        <div class="info-footer">
                            <span>由 “一位热心市民” 上报</span>
                            <span><fmt:formatDate value="${report.reportedAt}" pattern="yyyy年MM月dd日"/></span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <h3>太棒了！</h3>
                <p>目前还没有需要处理的环境问题，我们的家园正保持着整洁！</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
