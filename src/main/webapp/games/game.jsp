<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%-- 引入 JSTL core 标签库，以备不时之需 --%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>垃圾分类小游戏 - 智能垃圾分类教育平台</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gamestyle.css">

</head>

<body data-user-id="${sessionScope.loggedInUser.userId}">

<div class="game-page-container" style="max-width: 900px; margin: 20px auto; padding: 20px; background-color: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <h1>垃圾分类挑战</h1>
    <p>将垃圾拖拽到正确的分类桶中！</p>

    <div id="score-board" style="margin-bottom: 15px; font-size: 1.2em; text-align: center;">
        得分: <span id="score" style="font-weight: bold; color: #007bff;">0</span>
    </div>

    <div id="game-area" style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: space-around;">
        <div id="garbage-items-container" style="flex-basis: 300px; min-width: 280px;">
            <h2 style="font-size: 1.1em; margin-bottom: 10px;">待分类垃圾 (共 <span id="item-count">0</span> 项):</h2>
            <div id="garbage-items" style="min-height: 200px; border: 1px dashed #ccc; padding: 10px; border-radius: 5px; background-color: #f9f9f9; overflow-y: auto; max-height: 400px;">
            </div>
        </div>

        <div id="bins-container" style="flex-basis: 500px; min-width: 300px;">
            <h2 style="font-size: 1.1em; margin-bottom: 10px;">垃圾桶:</h2>
            <div id="bins">
                <div class="bin" id="recyclable-bin" data-type="recyclable">
                    <span class="bin-icon">♻️</span>
                    <span class="bin-label">可回收物</span>
                </div>
                <div class="bin" id="kitchen-bin" data-type="kitchen">
                    <span class="bin-icon">🍎</span>
                    <span class="bin-label">厨余垃圾</span>
                </div>
                <div class="bin" id="hazardous-bin" data-type="hazardous">
                    <span class="bin-icon">☠️</span>
                    <span class="bin-label">有害垃圾</span>
                </div>
                <div class="bin" id="other-bin" data-type="other">
                    <span class="bin-icon">🗑️</span>
                    <span class="bin-label">其他垃圾</span>
                </div>
            </div>
        </div>
    </div>

    <div id="game-end-message" style="display: none; margin-top: 25px; padding: 15px; border: 1px solid #ccc; background-color: #e9f5ff; text-align: center; border-radius: 5px; font-size: 1.1em; color: #333;">
    </div>

    <div style="text-align: center; margin-top: 25px; padding-bottom: 20px;">
        <button id="reset-button" class="game-action-button">重新开始</button>
        <a href="${pageContext.request.contextPath}/leaderboard?gameId=1" class="game-action-button primary">查看排行榜</a>
        <a href="${pageContext.request.contextPath}/" class="game-action-button secondary">返回首页</a>
    </div>
</div>


<script src="${pageContext.request.contextPath}/games/garbage_data.js"></script>
<script src="${pageContext.request.contextPath}/games/script.js"></script>

</body>
</html>