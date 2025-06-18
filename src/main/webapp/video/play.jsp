<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${video.title}"/></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* 【关键修改1】: 播放器容器的样式 */
        .video-player-wrapper {
            position: relative;
            width: 100%;
            padding-top: 56.25%; /* 16:9 宽高比 */
            background-color: #000;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer; /* 鼠标悬浮时显示为可点击的手指 */
        }

        /* 视频封面图片样式 */
        .video-player-wrapper .video-thumbnail {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover; /* 确保图片填满容器而不变形 */
            transition: opacity 0.3s ease;
        }

        /* 播放按钮的样式 */
        .video-player-wrapper .play-button-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80px;
            height: 80px;
            background-color: rgba(0, 0, 0, 0.6);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            pointer-events: none; /* 让点击事件可以穿透到下层图片 */
            transition: background-color 0.3s ease;
        }

        /* 用CSS绘制一个三角形的播放图标 */
        .video-player-wrapper .play-button-overlay::after {
            content: '';
            display: block;
            width: 0;
            height: 0;
            border-style: solid;
            border-width: 15px 0 15px 26px; /* 创建一个指向右边的三角形 */
            border-color: transparent transparent transparent white;
            margin-left: 5px; /* 微调图标位置使其居中 */
        }

        /* 鼠标悬浮时的交互效果 */
        .video-player-wrapper:hover .play-button-overlay {
            background-color: rgba(255, 0, 0, 0.8);
        }

        /* 播放器 iframe 的样式 */
        .video-player-wrapper iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<div class="container" style="max-width: 900px; margin: 20px auto; padding: 0 20px;">
    <a href="${pageContext.request.contextPath}/videos" style="display: inline-block; margin-bottom: 20px;">« 返回视频列表</a>

    <header style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px;">
        <h1><c:out value="${video.title}"/></h1>
    </header>

    <!-- 【关键修改2】: HTML结构，我们只放封面，不直接放iframe -->
    <!-- 我们将视频的URL作为 data-* 属性附加到容器上，方便JS获取 -->
    <div class="video-player-wrapper" id="video-container" data-video-src="${video.videoUrl}">
        <img src="${video.thumbnailUrl}" alt="视频封面: <c:out value='${video.title}'/>" class="video-thumbnail"
             onerror="this.onerror=null;this.src='https://placehold.co/800x450/EFEFEF/AAAAAA?text=封面加载失败';">
        <div class="play-button-overlay"></div>
    </div>

    <div class="video-description" style="margin-top: 20px;">
        <h3>视频简介</h3>
        <p><c:out value="${video.description}"/></p>
    </div>
</div>

<!-- 【关键修改3】: 添加JavaScript逻辑 -->
<script>
    // 获取视频播放器容器元素
    const videoContainer = document.getElementById('video-container');

    // 为容器添加一个点击事件监听器
    videoContainer.addEventListener('click', function() {
        // 从 data-video-src 属性中获取视频的嵌入URL
        const videoSrc = this.dataset.videoSrc;

        // 如果URL无效，则不执行任何操作
        if (!videoSrc) {
            console.error('未找到视频URL！');
            return;
        }

        // 为了实现点击后自动播放，我们在URL末尾添加 autoplay=1 参数
        // B站播放器支持这个参数
        const autoplayUrl = videoSrc.includes('?') ? videoSrc + '&autoplay=1' : videoSrc + '?autoplay=1';

        // 创建一个新的 <iframe> 元素
        const iframe = document.createElement('iframe');
        iframe.setAttribute('src', autoplayUrl);
        iframe.setAttribute('scrolling', 'no');
        iframe.setAttribute('border', '0');
        iframe.setAttribute('frameborder', 'no');
        iframe.setAttribute('framespacing', '0');
        iframe.setAttribute('allowfullscreen', 'true');
        iframe.setAttribute('allow', 'autoplay'); // 现代浏览器需要这个属性来允许自动播放

        // 清空容器内的所有内容（封面图片和播放按钮）
        this.innerHTML = '';

        // 将新创建的 <iframe> 播放器添加到容器中
        this.appendChild(iframe);

        // 移除容器上的 cursor: pointer 样式，因为现在已经是播放器了
        this.style.cursor = 'default';

    }, { once: true }); // { once: true } 表示这个事件监听器在触发一次后会自动移除，防止重复点击
</script>

</body>
</html>
