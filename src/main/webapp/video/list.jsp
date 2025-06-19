<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>教育视频列表 - 智能垃圾分类教育平台</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary: #4CAF50;
      --primary-dark: #388E3C;
      --secondary: #FFC107;
      --light: #F5F5F5;
      --dark: #333;
      --gray: #777;
      --card-shadow: 0 8px 16px rgba(0,0,0,0.1);
      --card-shadow-hover: 0 12px 24px rgba(0,0,0,0.15);
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
      background: linear-gradient(135deg, #f5f7fa 0%, #e4edf5 100%);
      color: var(--dark);
      line-height: 1.6;
      min-height: 100vh;
      padding: 20px 0;
    }

    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
    }

    /* 页头样式 */
    .page-header {
      text-align: center;
      margin: 30px 0;
      padding-bottom: 20px;
      position: relative;
    }

    .page-header h1 {
      font-size: 2.5rem;
      color: var(--primary-dark);
      margin-bottom: 10px;
      position: relative;
      display: inline-block;
    }

    .page-header h1::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 80px;
      height: 4px;
      background: var(--secondary);
      border-radius: 2px;
    }

    .page-description {
      color: var(--gray);
      max-width: 700px;
      margin: 0 auto 20px;
      font-size: 1.1rem;
      line-height: 1.7;
    }

    /* 返回链接样式 */
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: var(--primary);
      color: white;
      padding: 12px 24px;
      border-radius: 30px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 4px 6px rgba(76, 175, 80, 0.3);
      margin-bottom: 30px;
    }

    .back-link:hover {
      background: var(--primary-dark);
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(76, 175, 80, 0.4);
    }

    /* 视频网格样式 */
    .video-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 30px;
      margin-top: 30px;
    }

    .video-item {
      background: white;
      border-radius: 12px;
      overflow: hidden;
      transition: all 0.3s ease;
      box-shadow: var(--card-shadow);
      position: relative;
    }

    .video-item:hover {
      transform: translateY(-8px);
      box-shadow: var(--card-shadow-hover);
    }

    .video-thumbnail {
      position: relative;
      width: 100%;
      height: 180px;
      overflow: hidden;
    }

    .video-thumbnail img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
    }

    .video-item:hover .video-thumbnail img {
      transform: scale(1.05);
    }

    .play-icon {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: rgba(255, 255, 255, 0.8);
      width: 60px;
      height: 60px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0.9;
      transition: all 0.3s ease;
    }

    .play-icon i {
      color: var(--primary);
      font-size: 24px;
      margin-left: 4px;
    }

    .video-item:hover .play-icon {
      background: var(--primary);
    }

    .video-item:hover .play-icon i {
      color: white;
    }

    .video-content {
      padding: 20px;
    }

    .video-content h3 {
      font-size: 1.2rem;
      margin-bottom: 12px;
      color: var(--dark);
      transition: color 0.3s ease;
      height: 60px;
      overflow: hidden;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }

    .video-item:hover .video-content h3 {
      color: var(--primary);
    }

    .video-meta {
      display: flex;
      justify-content: space-between;
      color: var(--gray);
      font-size: 0.9rem;
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid #eee;
    }

    /* 无内容提示样式 */
    .empty-state {
      grid-column: 1 / -1;
      text-align: center;
      padding: 60px 20px;
      background: white;
      border-radius: 12px;
      box-shadow: var(--card-shadow);
    }

    .empty-state i {
      font-size: 4rem;
      color: #e0e0e0;
      margin-bottom: 20px;
    }

    .empty-state h3 {
      font-size: 1.8rem;
      color: var(--gray);
      margin-bottom: 15px;
    }

    .empty-state p {
      color: var(--gray);
      max-width: 600px;
      margin: 0 auto;
    }

    /* 搜索和筛选区域 */
    .filters {
      background: white;
      border-radius: 12px;
      padding: 20px;
      box-shadow: var(--card-shadow);
      margin-bottom: 30px;
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
    }

    .search-box {
      flex: 1;
      min-width: 300px;
      position: relative;
    }

    .search-box input {
      width: 100%;
      padding: 14px 20px 14px 50px;
      border: 2px solid #e0e0e0;
      border-radius: 30px;
      font-size: 1rem;
      transition: all 0.3s ease;
    }

    .search-box input:focus {
      border-color: var(--primary);
      outline: none;
      box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
    }

    .search-box i {
      position: absolute;
      left: 20px;
      top: 50%;
      transform: translateY(-50%);
      color: var(--gray);
    }

    .filter-select {
      padding: 12px 20px;
      border: 2px solid #e0e0e0;
      border-radius: 30px;
      font-size: 1rem;
      background: white;
      min-width: 200px;
      cursor: pointer;
    }

    .filter-btn {
      background: var(--primary);
      color: white;
      border: none;
      padding: 12px 30px;
      border-radius: 30px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }

    .filter-btn:hover {
      background: var(--primary-dark);
      transform: translateY(-2px);
    }

    /* 响应式设计 */
    @media (max-width: 768px) {
      .video-grid {
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      }

      .page-header h1 {
        font-size: 2rem;
      }

      .filters {
        flex-direction: column;
      }

      .search-box {
        min-width: 100%;
      }
    }

    @media (max-width: 480px) {
      .video-grid {
        grid-template-columns: 1fr;
      }

      .page-header h1 {
        font-size: 1.8rem;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <div class="page-header">
    <h1><i class="fas fa-video"></i> 教育视频资源</h1>
    <p class="page-description">探索我们的垃圾分类教育视频库，学习如何正确分类垃圾、回收利用资源，共同创建更清洁、更绿色的环境。</p>
  </div>

  <a href="${pageContext.request.contextPath}/" class="back-link">
    <i class="fas fa-arrow-left"></i> 返回首页
  </a>

  <div class="filters">
    <div class="search-box">
      <i class="fas fa-search"></i>
      <input type="text" placeholder="搜索视频...">
    </div>
    <select class="filter-select">
      <option>所有分类</option>
      <option>基础知识</option>
      <option>回收技巧</option>
      <option>环保实践</option>
    </select>
    <select class="filter-select">
      <option>排序方式</option>
      <option>最新发布</option>
      <option>最受欢迎</option>
    </select>
    <button class="filter-btn">筛选</button>
  </div>

  <div class="video-grid">
    <c:choose>
      <c:when test="${not empty videoList}">
        <c:forEach items="${videoList}" var="video">
          <div class="video-item">
            <a href="${pageContext.request.contextPath}/play?id=${video.videoId}">
              <div class="video-thumbnail">
                <img src="${video.thumbnailUrl}" alt="<c:out value='${video.title}'/>"
                     onerror="this.onerror=null;this.src='https://placehold.co/600x400/e0f7fa/0288d1?text=垃圾分类教育'">
                <div class="play-icon">
                  <i class="fas fa-play"></i>
                </div>
              </div>
              <div class="video-content">
                <h3><c:out value="${video.title}"/></h3>
                <div class="video-meta">
                  <span><i class="far fa-clock"></i> 15:30</span>
                  <span><i class="far fa-eye"></i> 1.2K 观看</span>
                </div>
              </div>
            </a>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <i class="fas fa-film"></i>
          <h3>暂无教育视频</h3>
          <p>目前没有已发布的视频资源，请稍后再来查看或联系管理员获取更多信息。</p>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  // 搜索功能
  document.querySelector('.search-box input').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const videoItems = document.querySelectorAll('.video-item');

    videoItems.forEach(item => {
      const title = item.querySelector('h3').textContent.toLowerCase();
      if (title.includes(searchTerm)) {
        item.style.display = 'block';
      } else {
        item.style.display = 'none';
      }
    });
  });
</script>
</body>
</html>