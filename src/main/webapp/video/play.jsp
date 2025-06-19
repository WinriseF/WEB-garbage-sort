<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${video.title}"/> - 智能垃圾分类教育平台</title>
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
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* 返回按钮样式 */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: white;
            color: var(--primary);
            padding: 12px 24px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: var(--card-shadow);
            margin: 30px 0 20px;
            border: 2px solid var(--primary);
        }

        .back-btn:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--card-shadow-hover);
        }

        /* 视频头部样式 */
        .video-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .video-header h1 {
            font-size: 2.2rem;
            color: var(--primary-dark);
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
            padding-bottom: 15px;
        }

        .video-header h1::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: var(--secondary);
            border-radius: 2px;
        }

        /* 视频播放器样式 */
        .video-container {
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--card-shadow-hover);
            position: relative;
            background: #000;
            margin-bottom: 30px;
        }

        .video-player-wrapper {
            position: relative;
            width: 100%;
            padding-top: 56.25%;
            cursor: pointer;
        }

        .video-thumbnail {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: opacity 0.3s ease;
        }

        .play-button-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 100px;
            height: 100px;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            pointer-events: none;
            transition: all 0.3s ease;
            opacity: 0.9;
        }

        .play-button-overlay i {
            color: white;
            font-size: 40px;
            margin-left: 8px;
        }

        .video-player-wrapper:hover .play-button-overlay {
            background: rgba(255, 0, 0, 0.8);
            transform: translate(-50%, -50%) scale(1.05);
        }

        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }

        /* 视频信息区域 */
        .video-info {
            display: flex;
            gap: 30px;
            margin-bottom: 40px;
        }

        .video-description {
            flex: 1;
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: var(--card-shadow);
        }

        .video-description h2 {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--primary);
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--light);
        }

        .video-description p {
            line-height: 1.8;
            color: var(--dark);
            font-size: 1.05rem;
        }

        .video-meta {
            width: 300px;
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--card-shadow);
        }

        .meta-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .meta-item:last-child {
            border-bottom: none;
        }

        .meta-label {
            color: var(--gray);
            font-weight: 500;
        }

        .meta-value {
            color: var(--dark);
            font-weight: 600;
        }

        /* 相关视频区域 */
        .related-videos {
            margin-top: 40px;
            margin-bottom: 60px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.5rem;
            color: var(--primary-dark);
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--secondary);
        }

        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
        }

        .video-item {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: var(--card-shadow);
        }

        .video-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow-hover);
        }

        .video-thumb {
            position: relative;
            height: 160px;
        }

        .video-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .video-content {
            padding: 20px;
        }

        .video-content h3 {
            font-size: 1.1rem;
            margin-bottom: 8px;
            height: 50px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .video-content a {
            text-decoration: none;
            color: var(--dark);
        }

        .video-stats {
            display: flex;
            justify-content: space-between;
            color: var(--gray);
            font-size: 0.9rem;
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .video-info {
                flex-direction: column;
            }

            .video-meta {
                width: 100%;
            }
        }

        @media (max-width: 768px) {
            .video-header h1 {
                font-size: 1.8rem;
            }

            .video-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
        }

        @media (max-width: 576px) {
            .video-header h1 {
                font-size: 1.5rem;
            }

            .video-description, .video-meta {
                padding: 20px;
            }

            .video-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <a href="${pageContext.request.contextPath}/videos" class="back-btn">
        <i class="fas fa-arrow-left"></i> 返回视频列表
    </a>

    <div class="video-header">
        <h1><i class="fas fa-play-circle"></i> <c:out value="${video.title}"/></h1>
    </div>

    <div class="video-container">
        <div class="video-player-wrapper" id="video-container" data-video-src="${video.videoUrl}">
            <img src="${video.thumbnailUrl}" alt="视频封面: <c:out value='${video.title}'/>" class="video-thumbnail"
                 onerror="this.onerror=null;this.src='https://placehold.co/800x450/e0f7fa/0288d1?text=垃圾分类教育'">
            <div class="play-button-overlay">
                <i class="fas fa-play"></i>
            </div>
        </div>
    </div>

    <div class="video-info">
        <div class="video-description">
            <h2><i class="fas fa-info-circle"></i> 视频简介</h2>
            <p><c:out value="${video.description}"/></p>
        </div>

        <div class="video-meta">
            <div class="meta-item">
                <span class="meta-label"><i class="far fa-clock"></i> 时长</span>
                <span class="meta-value">7:30</span>
            </div>
            <div class="meta-item">
                <span class="meta-label"><i class="far fa-calendar-alt"></i> 上传日期</span>
                <span class="meta-value">2023-10-15</span>
            </div>
            <div class="meta-item">
                <span class="meta-label"><i class="far fa-eye"></i> 观看次数</span>
                <span class="meta-value">1,254</span>
            </div>
            <div class="meta-item">
                <span class="meta-label"><i class="far fa-thumbs-up"></i> 点赞数</span>
                <span class="meta-value">186</span>
            </div>
            <div class="meta-item">
                <span class="meta-label"><i class="fas fa-tags"></i> 分类</span>
                <span class="meta-value">环保知识</span>
            </div>
        </div>
    </div>

    <div class="related-videos">
        <h2 class="section-title"><i class="fas fa-film"></i> 相关推荐</h2>
        <div class="video-grid">
            <div class="video-item">
                <a href="#">
                    <div class="video-thumb">
                        <img src="https://placehold.co/400x225/EFEFEF/AAAAAA?text=垃圾分类基础" alt="垃圾分类基础">
                    </div>
                    <div class="video-content">
                        <h3>垃圾分类基础知识入门教程</h3>
                        <div class="video-stats">
                            <span>12:45</span>
                            <span>864次观看</span>
                        </div>
                    </div>
                </a>
            </div>

            <div class="video-item">
                <a href="#">
                    <div class="video-thumb">
                        <img src="https://placehold.co/400x225/EFEFEF/AAAAAA?text=厨余垃圾处理" alt="厨余垃圾处理">
                    </div>
                    <div class="video-content">
                        <h3>家庭厨余垃圾处理与堆肥技巧</h3>
                        <div class="video-stats">
                            <span>18:20</span>
                            <span>1,024次观看</span>
                        </div>
                    </div>
                </a>
            </div>

            <div class="video-item">
                <a href="#">
                    <div class="video-thumb">
                        <img src="https://placehold.co/400x225/EFEFEF/AAAAAA?text=回收利用" alt="回收利用">
                    </div>
                    <div class="video-content">
                        <h3>塑料回收利用的完整流程解析</h3>
                        <div class="video-stats">
                            <span>22:15</span>
                            <span>1,532次观看</span>
                        </div>
                    </div>
                </a>
            </div>

            <div class="video-item">
                <a href="#">
                    <div class="video-thumb">
                        <img src="https://placehold.co/400x225/EFEFEF/AAAAAA?text=环保生活" alt="环保生活">
                    </div>
                    <div class="video-content">
                        <h3>10个环保生活小技巧，让地球更美好</h3>
                        <div class="video-stats">
                            <span>14:30</span>
                            <span>2,156次观看</span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    // 视频播放器交互逻辑
    const videoContainer = document.getElementById('video-container');

    videoContainer.addEventListener('click', function() {
        const videoSrc = this.dataset.videoSrc;

        if (!videoSrc) {
            console.error('未找到视频URL！');
            return;
        }

        // 添加自动播放参数
        const autoplayUrl = videoSrc.includes('?') ?
            videoSrc + '&autoplay=1' :
            videoSrc + '?autoplay=1';

        // 创建iframe元素
        const iframe = document.createElement('iframe');
        iframe.setAttribute('src', autoplayUrl);
        iframe.setAttribute('allowfullscreen', 'true');
        iframe.setAttribute('allow', 'autoplay');

        // 替换容器内容
        this.innerHTML = '';
        this.appendChild(iframe);
        this.style.cursor = 'default';

        // 添加播放成功效果
        this.parentElement.classList.add('playing');

    }, { once: true });

    // 添加简单的观看计数动画效果
    document.addEventListener('DOMContentLoaded', function() {
        const watchCount = document.querySelector('.meta-item:nth-child(3) .meta-value');
        let count = 1254;

        setInterval(() => {
            count += Math.floor(Math.random() * 3) + 1;
            watchCount.textContent = count.toLocaleString();
        }, 5000);
    });
</script>
</body>
</html>