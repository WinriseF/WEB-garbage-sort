<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>游戏排行榜 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <%-- 假设有通用样式 --%>
    <style>
        .leaderboard-container { max-width: 800px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .leaderboard-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .leaderboard-table th, .leaderboard-table td { border: 1px solid #ddd; padding: 10px 12px; text-align: left; }
        .leaderboard-table th { background-color: #f2f2f2; font-weight: bold; }
        .leaderboard-table tbody tr:nth-child(even) { background-color: #f9f9f9; }
        .leaderboard-table tbody tr:hover { background-color: #e9e9e9; }
        .rank-col { width: 50px; text-align: center; }
        .score-col { width: 80px; text-align: right; }
        .duration-col { width: 100px; text-align: right; }
        .no-data { text-align: center; padding: 20px; color: #777; }
    </style>
</head>
<body>
<div class="leaderboard-container">
    <h1>游戏排行榜
        <c:choose>
            <c:when test="${gameIdForTitle == 1}"> (拖拽分类)</c:when>
            <%-- 可以为其他游戏 ID 添加更多 case --%>
            <c:otherwise> (游戏 ID: ${gameIdForTitle})</c:otherwise>
        </c:choose>
    </h1>

    <c:choose>
        <c:when test="${not empty leaderboardData}">
            <table class="leaderboard-table">
                <thead>
                <tr>
                    <th class="rank-col">排名</th>
                    <th>昵称</th>
                    <th class="score-col">分数</th>
                    <th class="duration-col">用时(秒)</th>
                    <th>游戏时间</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${leaderboardData}" var="entry" varStatus="loop">
                    <tr>
                        <td class="rank-col">${loop.count}</td>
                        <td><c:out value="${entry.nickname}"/></td>
                        <td class="score-col">${entry.score}</td>
                        <td class="duration-col">
                            <c:choose>
                                <c:when test="${not empty entry.durationSeconds}">${entry.durationSeconds}</c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${entry.playedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p class="no-data">排行榜暂无数据。</p>
        </c:otherwise>
    </c:choose>
    <p style="margin-top: 20px; text-align: center;">
        <a href="${pageContext.request.contextPath}/games/dragdrop/game.jsp">返回游戏</a> <%-- 假设游戏页面路径 --%>
        | <a href="${pageContext.request.contextPath}/">返回首页</a>
    </p>
</div>
</body>
</html>