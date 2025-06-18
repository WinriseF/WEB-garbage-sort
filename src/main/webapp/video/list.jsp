<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>教育视频列表 - 智能垃圾分类教育平台</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .container { max-width: 1200px; margin: 20px auto; padding: 0 20px; }
    .page-header { margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
    .page-header h1 { margin: 0; }
    .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; }
    .back-link:hover { text-decoration: underline; }
    .video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
    .video-item { border: 1px solid #ddd; border-radius: 8px; overflow: hidden; text-align: center; background-color: #fff; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .video-item img { width: 100%; height: auto; aspect-ratio: 16 / 9; object-fit: cover; }
    .video-item h3 { margin: 10px 15px; font-size: 1.1em; }
    .video-item a { text-decoration: none; color: #333; display: block; }
  </style>
</head>
<body>
<div class="container">
  <div class="page-header">
    <h1>教育视频</h1>
  </div>
  <a href="${pageContext.request.contextPath}/" class="back-link">« 返回首页</a>

  <div class="video-grid">
    <c:choose>
      <c:when test="${not empty videoList}">
        <c:forEach items="${videoList}" var="video">
          <div class="video-item">
            <a href="${pageContext.request.contextPath}/play?id=${video.videoId}">
              <img src="${video.thumbnailUrl}" alt="<c:out value='${video.title}'/>"
                   onerror="this.onerror=null;this.src='https://placehold.co/400x225/EFEFEF/AAAAAA?text=封面加载失败';">
              <h3><c:out value="${video.title}"/></h3>
            </a>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <p>暂无已发布的视频。</p>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</body>
</html>
