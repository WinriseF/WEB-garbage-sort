/*
 Navicat Premium Dump SQL

 Source Server         : mysqld
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : znljfl

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 19/06/2025 20:53:57
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for article_category_mapping
-- ----------------------------
DROP TABLE IF EXISTS `article_category_mapping`;
CREATE TABLE `article_category_mapping`  (
  `article_id` int NOT NULL COMMENT '文章ID，外键关联KnowledgeArticles表',
  `category_id` int NOT NULL COMMENT '分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`article_id`, `category_id`) USING BTREE,
  INDEX `fk_Article_Category_Mapping_VideoCategories_idx`(`category_id` ASC) USING BTREE,
  INDEX `fk_Article_Category_Mapping_KnowledgeArticles_idx`(`article_id` ASC) USING BTREE,
  CONSTRAINT `fk_Article_Category_Mapping_KnowledgeArticles` FOREIGN KEY (`article_id`) REFERENCES `knowledgearticles` (`article_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Article_Category_Mapping_VideoCategories` FOREIGN KEY (`category_id`) REFERENCES `videocategories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章与分类的关联映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of article_category_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for environmentalreports
-- ----------------------------
DROP TABLE IF EXISTS `environmentalreports`;
CREATE TABLE `environmentalreports`  (
  `report_id` int NOT NULL AUTO_INCREMENT COMMENT '上报记录唯一标识ID，主键',
  `user_id` int NOT NULL COMMENT '上报用户ID，外键关联Users表',
  `report_type` enum('improper_sorting','littering','pollution_incident','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上报问题类型',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '问题详细描述',
  `photo_video_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '相关照片或视频的URL列表 (可存储为JSON数组字符串或逗号分隔的字符串)',
  `latitude` decimal(10, 8) NULL DEFAULT NULL COMMENT '问题发生地点的纬度',
  `longitude` decimal(11, 8) NULL DEFAULT NULL COMMENT '问题发生地点的经度',
  `address_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户填写的地址或系统解析的地址文本',
  `reported_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上报日期时间',
  `status` enum('pending_review','verified','forwarded','resolved','invalid') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending_review' COMMENT '上报信息处理状态',
  `admin_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '管理员审核或处理备注',
  `region_id` int NULL DEFAULT NULL COMMENT '问题发生地区ID，外键关联Regions表',
  PRIMARY KEY (`report_id`) USING BTREE,
  INDEX `fk_EnvironmentalReports_Users_idx`(`user_id` ASC) USING BTREE,
  INDEX `fk_EnvironmentalReports_Regions_idx`(`region_id` ASC) USING BTREE,
  CONSTRAINT `fk_EnvironmentalReports_Regions` FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_EnvironmentalReports_Users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '环境问题上报表 (\"随手拍\")' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of environmentalreports
-- ----------------------------
INSERT INTO `environmentalreports` VALUES (1, 8, 'improper_sorting', 'aaa', NULL, NULL, NULL, 'aaa', '2025-06-19 10:19:23', 'invalid', '', NULL);
INSERT INTO `environmentalreports` VALUES (2, 8, 'improper_sorting', '啊啊', NULL, NULL, NULL, '啊啊啊', '2025-06-19 11:53:42', 'invalid', '', NULL);
INSERT INTO `environmentalreports` VALUES (3, 8, 'improper_sorting', '啊啊', NULL, NULL, NULL, '啊啊啊', '2025-06-19 11:53:49', 'invalid', '', NULL);
INSERT INTO `environmentalreports` VALUES (4, 8, 'improper_sorting', 'aaa', 'uploads/reports/f1fcfd6a-978b-4cdd-ba6e-4307b7db7b82_1.webp', NULL, NULL, 'aaa', '2025-06-19 12:09:42', 'verified', '', NULL);
INSERT INTO `environmentalreports` VALUES (5, 8, 'pollution_incident', '水是黑色的，上面工厂乱排乱放', 'uploads/reports/31a61287-b0cb-447a-9c93-be223a4bbf68_176504ce4a6209cf5a1e674a12c46068.jpg', NULL, NULL, '成都XX大学XX渠', '2025-06-19 12:47:08', 'verified', '确实，建议去西南XX大学', NULL);

-- ----------------------------
-- Table structure for games
-- ----------------------------
DROP TABLE IF EXISTS `games`;
CREATE TABLE `games`  (
  `game_id` int NOT NULL AUTO_INCREMENT COMMENT '游戏唯一标识ID，主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏名称 (如: 垃圾拖拽分类, 分类知识问答)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '游戏玩法描述',
  `game_type` enum('drag_and_drop','quiz') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '游戏类型',
  `difficulty_level` enum('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'medium' COMMENT '游戏默认难度级别',
  PRIMARY KEY (`game_id`) USING BTREE,
  UNIQUE INDEX `name_UNIQUE`(`name` ASC) USING BTREE COMMENT '游戏名称唯一'
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '游戏定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of games
-- ----------------------------
INSERT INTO `games` VALUES (1, '垃圾拖拽分类', '将垃圾图标拖到对应垃圾桶', 'drag_and_drop', 'medium');

-- ----------------------------
-- Table structure for knowledgearticles
-- ----------------------------
DROP TABLE IF EXISTS `knowledgearticles`;
CREATE TABLE `knowledgearticles`  (
  `article_id` int NOT NULL AUTO_INCREMENT COMMENT '文章唯一标识ID，主键',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章标题',
  `content_html` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文章内容，以HTML格式存储，支持图文混排',
  `author_id` int NULL DEFAULT NULL COMMENT '文章作者ID，外键关联Users表 (通常是admin或editor)',
  `publish_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文章发布日期时间',
  `views_count` int NULL DEFAULT 0 COMMENT '文章被阅读的次数',
  `status` enum('draft','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'draft' COMMENT '文章状态 (草稿, 已发布, 已归档)',
  `main_category_id` int NULL DEFAULT NULL COMMENT '文章所属的主要分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`article_id`) USING BTREE,
  INDEX `fk_KnowledgeArticles_Users_idx`(`author_id` ASC) USING BTREE,
  INDEX `fk_KnowledgeArticles_VideoCategories_idx`(`main_category_id` ASC) USING BTREE,
  CONSTRAINT `fk_KnowledgeArticles_Users` FOREIGN KEY (`author_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_KnowledgeArticles_VideoCategories` FOREIGN KEY (`main_category_id`) REFERENCES `videocategories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledgearticles
-- ----------------------------
INSERT INTO `knowledgearticles` VALUES (6, '测试1', '<style>\r\n    .article-section {\r\n        margin-bottom: 25px;\r\n        padding: 15px;\r\n        border-left: 4px solid #eee;\r\n    }\r\n    .article-section h3 {\r\n        margin-top: 0;\r\n        font-size: 20px;\r\n    }\r\n    .article-section ul {\r\n        list-style-type: disc;\r\n        padding-left: 20px;\r\n    }\r\n    .recyclable { border-color: #007bff; }\r\n    .kitchen-waste { border-color: #28a745; }\r\n    .hazardous-waste { border-color: #dc3545; }\r\n    .other-waste { border-color: #6c757d; }\r\n</style>\r\n\r\n<p>大家好！垃圾分类是城市文明的重要标志，也是我们每个公民应尽的责任。正确的垃圾分类不仅能让我们的家园更美丽，还能变废为宝，节约资源。今天，就让我们一起来系统地学习一下垃圾分类的知识吧！</p>\r\n<p>目前，我们主要遵循“四分法”，即将生活垃圾分为：<strong>可回收物、厨余垃圾、有害垃圾</strong>和<strong>其他垃圾</strong>。</p>\r\n\r\n<div class=\"article-section recyclable\">\r\n    <h3>一、可回收物 (蓝色垃圾桶)</h3>\r\n    <p><strong>定义：</strong>指适宜回收、可循环利用的生活废弃物。记住一个口诀：“纸、塑、金、玻、衣”。</p>\r\n    <h4>常见物品:</h4>\r\n    <ul>\r\n        <li><strong>废纸类：</strong>报纸、杂志、书籍、宣传单、纸箱、包装纸、信封、笔记本等。</li>\r\n        <li><strong>塑料类：</strong>塑料瓶（如饮料瓶、洗发水瓶）、塑料桶、塑料玩具、塑料盆、泡沫塑料等。</li>\r\n        <li><strong>金属类：</strong>易拉罐、金属罐头盒、废旧铁锅、铜线、铝制品等。</li>\r\n        <li><strong>玻璃类：</strong>玻璃瓶、玻璃杯、窗户玻璃、镜子等。</li>\r\n        <li><strong>纺织衣物类：</strong>旧衣服、床单、被套、书包、布鞋等。</li>\r\n    </ul>\r\n    <h4>投放要求:</h4>\r\n    <p>投放时应尽量保持清洁干燥，避免污染。废纸应尽量叠放整齐；塑料瓶、易拉罐等应清空内容物并压扁；玻璃制品应小心轻放，以防破碎伤人。</p>\r\n</div>\r\n\r\n<div class=\"article-section kitchen-waste\">\r\n    <h3>二、厨余垃圾 (绿色垃圾桶)</h3>\r\n    <p><strong>定义：</strong>也叫“湿垃圾”，指居民日常生活及食品加工、饮食服务、单位供餐等活动中产生的垃圾。通俗讲就是容易腐烂的生物质废弃物。</p>\r\n    <h4>常见物品:</h4>\r\n    <ul>\r\n        <li><strong>食材废料：</strong>菜叶、瓜果皮、蛋壳、茶叶渣、骨头、鱼刺、剩菜剩饭等。</li>\r\n        <li><strong>其他：</strong>过期的食品、盆栽绿植的残枝落叶等。</li>\r\n    </ul>\r\n    <h4>投放要求:</h4>\r\n    <p>应从塑料袋中取出，沥干水分后投放。大块的骨头、硬贝壳等难以腐烂分解的，建议投入“其他垃圾”。</p>\r\n</div>\r\n\r\n<div class=\"article-section hazardous-waste\">\r\n    <h3>三、有害垃圾 (红色垃圾桶)</h3>\r\n    <p><strong>定义：</strong>指对人体健康或者自然环境造成直接或者潜在危害的生活废弃物。</p>\r\n    <h4>常见物品:</h4>\r\n    <ul>\r\n        <li><strong>电池类：</strong>充电电池、纽扣电池、蓄电池。</li>\r\n        <li><strong>灯管类：</strong>废旧的节能灯、荧光灯管。</li>\r\n        <li><strong>化学品类：</strong>过期药品、杀虫剂、消毒剂、油漆桶、废弃化妆品等。</li>\r\n        <li><strong>其他：</strong>废旧温度计、血压计等。</li>\r\n    </ul>\r\n    <h4>投放要求:</h4>\r\n    <p>投放时要特别注意！应小心轻放，不要破坏包装。易破碎的（如灯管）应连带包装或包裹后投放；过期药品最好连同包装盒一起投放。这些垃圾需要特殊安全处理。</p>\r\n</div>\r\n\r\n<div class=\"article-section other-waste\">\r\n    <h3>四、其他垃圾 (灰色垃圾桶)</h3>\r\n    <p><strong>定义：</strong>也叫“干垃圾”，指除上述三类之外的其他生活废弃物。</p>\r\n    <h4>常见物品:</h4>\r\n    <ul>\r\n        <li><strong>污染严重的纸张：</strong>使用过的餐巾纸、卫生间用纸、尿不湿等。</li>\r\n        <li><strong>难以回收的废弃物：</strong>烟头、尘土、大骨头、陶瓷碎片、一次性餐具、旧毛巾等。</li>\r\n        <li><strong>其他：</strong>宠物粪便、用过的口罩等。</li>\r\n    </ul>\r\n    <h4>投放要求:</h4>\r\n    <p>尽量沥干水分，难以分辨类别的垃圾也可以投入此类。</p>\r\n</div>\r\n\r\n<hr>\r\n<p>垃圾分类，举手之劳，功在当代，利在千秋。让我们从自身做起，从现在做起，共同守护我们美丽的地球家园！</p>\r\n', 8, '2025-06-19 09:14:56', 20, 'draft', NULL);
INSERT INTO `knowledgearticles` VALUES (7, '垃圾分类知识宣传', '<!DOCTYPE html>\r\n<html lang=\"zh-CN\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <!-- 引入一个外部字体，让页面更好看 -->\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;700&display=swap\" rel=\"stylesheet\">\r\n    <style>\r\n        /* 全局样式 */\r\n        .article-body {\r\n            font-family: \'Noto Sans SC\', sans-serif;\r\n            line-height: 1.8;\r\n            color: #333;\r\n        }\r\n\r\n        /* 介绍部分 */\r\n        .intro-text {\r\n            font-size: 1.1em;\r\n            color: #555;\r\n            text-align: center;\r\n            margin-bottom: 40px;\r\n        }\r\n\r\n        /* 四大分类网格布局 */\r\n        .category-grid {\r\n            display: grid;\r\n            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));\r\n            gap: 25px;\r\n            margin-bottom: 40px;\r\n        }\r\n        \r\n        /* 分类卡片统一样式 */\r\n        .category-card {\r\n            background-color: #fff;\r\n            border-radius: 12px;\r\n            padding: 25px;\r\n            box-shadow: 0 4px 15px rgba(0,0,0,0.08);\r\n            border-top: 5px solid;\r\n            transition: transform 0.3s ease, box-shadow 0.3s ease;\r\n        }\r\n        .category-card:hover {\r\n            transform: translateY(-5px);\r\n            box-shadow: 0 8px 25px rgba(0,0,0,0.12);\r\n        }\r\n\r\n        /* 卡片头部（图标和标题） */\r\n        .card-header {\r\n            display: flex;\r\n            align-items: center;\r\n            margin-bottom: 15px;\r\n        }\r\n        .card-header img {\r\n            width: 40px;\r\n            height: 40px;\r\n            margin-right: 15px;\r\n        }\r\n        .card-header h3 {\r\n            margin: 0;\r\n            font-size: 22px;\r\n        }\r\n        \r\n        /* 不同分类的颜色 */\r\n        .card-kitchen { border-color: #28a745; } /* 厨余垃圾 - 绿色 */\r\n        .card-recyclable { border-color: #007bff; } /* 可回收物 - 蓝色 */\r\n        .card-hazardous { border-color: #dc3545; } /* 有害垃圾 - 红色 */\r\n        .card-other { border-color: #6c757d; } /* 其他垃圾 - 灰色 */\r\n        \r\n        .card-kitchen h3 { color: #28a745; }\r\n        .card-recyclable h3 { color: #007bff; }\r\n        .card-hazardous h3 { color: #dc3545; }\r\n        .card-other h3 { color: #6c757d; }\r\n        \r\n        /* 投放要求部分 */\r\n        .requirements-section {\r\n            margin-top: 50px;\r\n            background-color: #f8f9fa;\r\n            padding: 30px;\r\n            border-radius: 12px;\r\n        }\r\n        .requirements-section h2 {\r\n            text-align: center;\r\n            margin-bottom: 30px;\r\n        }\r\n        \r\n        /* 投放要求的具体条目 */\r\n        .requirement-item h4 {\r\n            font-size: 18px;\r\n            border-bottom: 2px solid #eee;\r\n            padding-bottom: 5px;\r\n        }\r\n\r\n    </style>\r\n</head>\r\n<body class=\"article-body\">\r\n\r\n    <p class=\"intro-text\">\r\n        垃圾分类是城市文明的重要标志，也是我们每个公民应尽的责任。<br>\r\n        正确的垃圾分类不仅能让我们的家园更美丽，还能变废为宝，节约资源。\r\n    </p>\r\n\r\n    <h2>一、垃圾分类四大类</h2>\r\n    <div class=\"category-grid\">\r\n        <!-- 厨余垃圾卡片 -->\r\n        <div class=\"category-card card-kitchen\">\r\n            <div class=\"card-header\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/apple-core.png\" alt=\"[厨余垃圾图标]\">\r\n                <h3>厨余垃圾 (湿垃圾)</h3>\r\n            </div>\r\n            <p>包括剩菜剩饭、骨头、菜根菜叶、果皮等食品类废物。</p>\r\n        </div>\r\n        <!-- 可回收物卡片 -->\r\n        <div class=\"category-card card-recyclable\">\r\n            <div class=\"card-header\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/recycle-bin.png\" alt=\"[可回收物图标]\">\r\n                <h3>可回收物</h3>\r\n            </div>\r\n            <p>主要包括废纸、塑料、玻璃、金属和布料五大类。</p>\r\n        </div>\r\n        <!-- 有害垃圾卡片 -->\r\n        <div class=\"category-card card-hazardous\">\r\n            <div class=\"card-header\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/battery.png\" alt=\"[有害垃圾图标]\">\r\n                <h3>有害垃圾</h3>\r\n            </div>\r\n            <p>包括电池、荧光灯管、过期药品、油漆桶等对人体或环境有害的废弃物。</p>\r\n        </div>\r\n        <!-- 其他垃圾卡片 -->\r\n        <div class=\"category-card card-other\">\r\n             <div class=\"card-header\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/trash.png\" alt=\"[其他垃圾图标]\">\r\n                <h3>其他垃圾 (干垃圾)</h3>\r\n            </div>\r\n            <p>包括除上述几类垃圾之外的砖瓦陶瓷、渣土、卫生间废纸等难以回收的废弃物。</p>\r\n        </div>\r\n    </div>\r\n\r\n    <div class=\"requirements-section\">\r\n        <h2>二、垃圾分类投放要求</h2>\r\n        <div class=\"requirement-item\">\r\n            <h4 style=\"color: #28a745;\">厨余垃圾投放要求</h4>\r\n            <p>指易腐烂的有机质垃圾。投放前应尽量沥干水分，去除包装物（如塑料袋），纯内容物投放。</p>\r\n        </div>\r\n        <div class=\"requirement-item\">\r\n            <h4 style=\"color: #007bff;\">可回收物投放要求</h4>\r\n            <p>应保持清洁干燥，避免污染。立体包装物（如瓶子、盒子）应清空内容物，清洁后压扁投放，以节省空间。</p>\r\n        </div>\r\n        <div class=\"requirement-item\">\r\n            <h4 style=\"color: #dc3545;\">有害垃圾投放要求</h4>\r\n            <p>投放时应注意轻拿轻放，保持包装完整。易破碎的（如灯管）或易挥发的（如油漆）应包裹后投放，确保安全。</p>\r\n        </div>\r\n        <div class=\"requirement-item\">\r\n            <h4 style=\"color: #6c757d;\">其他垃圾投放要求</h4>\r\n            <p>指除以上三类外的所有垃圾。应确保无害、非厨余、无回收价值，并投入对应的垃圾容器中。</p>\r\n        </div>\r\n    </div>\r\n\r\n</body>\r\n</html>\r\n', 8, '2025-06-19 09:42:50', 15, 'published', NULL);
INSERT INTO `knowledgearticles` VALUES (8, '问：为什么要垃圾分类?', '<!DOCTYPE html>\r\n<html lang=\"zh-CN\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <!-- 引入一个外部字体，让页面更好看 -->\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;700&display=swap\" rel=\"stylesheet\">\r\n    <style>\r\n        /* 全局样式 */\r\n        .benefits-body {\r\n            font-family: \'Noto Sans SC\', sans-serif;\r\n            line-height: 1.8;\r\n            color: #333;\r\n            background-color: #f9f9f9;\r\n        }\r\n\r\n        .benefits-container {\r\n            max-width: 1000px;\r\n            margin: 30px auto;\r\n            padding: 20px;\r\n        }\r\n\r\n        .benefits-header h1 {\r\n            text-align: center;\r\n            font-size: 28px;\r\n            margin-bottom: 15px;\r\n        }\r\n\r\n        .benefits-header p {\r\n            text-align: center;\r\n            font-size: 1.1em;\r\n            color: #555;\r\n            max-width: 800px;\r\n            margin: 0 auto 40px auto;\r\n        }\r\n\r\n        /* 三大好处的网格布局 */\r\n        .benefits-grid {\r\n            display: grid;\r\n            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));\r\n            gap: 30px;\r\n        }\r\n        \r\n        /* 好处卡片统一样式 */\r\n        .benefit-card {\r\n            background-color: #fff;\r\n            border-radius: 15px;\r\n            padding: 30px;\r\n            box-shadow: 0 5px 20px rgba(0,0,0,0.07);\r\n            text-align: center;\r\n            border-bottom: 5px solid;\r\n            transition: transform 0.3s ease, box-shadow 0.3s ease;\r\n        }\r\n        .benefit-card:hover {\r\n            transform: translateY(-8px);\r\n            box-shadow: 0 10px 30px rgba(0,0,0,0.1);\r\n        }\r\n\r\n        .benefit-card img {\r\n            width: 80px;\r\n            height: 80px;\r\n            margin-bottom: 20px;\r\n        }\r\n        \r\n        .benefit-card h2 {\r\n            margin-top: 0;\r\n            font-size: 22px;\r\n            margin-bottom: 15px;\r\n        }\r\n        \r\n        .benefit-card p {\r\n            font-size: 16px;\r\n            color: #666;\r\n        }\r\n        \r\n        /* 不同卡片的颜色 */\r\n        .card-land { border-color: #5cb85c; } /* 减少占地 - 绿色 */\r\n        .card-pollution { border-color: #337ab7; } /* 减少污染 - 蓝色 */\r\n        .card-treasure { border-color: #f0ad4e; } /* 变废为宝 - 橙色 */\r\n        \r\n        .card-land h2 { color: #5cb85c; }\r\n        .card-pollution h2 { color: #337ab7; }\r\n        .card-treasure h2 { color: #f0ad4e; }\r\n        \r\n    </style>\r\n</head>\r\n<body class=\"benefits-body\">\r\n\r\n    <div class=\"benefits-container\">\r\n\r\n        <div class=\"benefits-header\">\r\n            <h1>垃圾分类的重大意义</h1>\r\n            <p>垃圾通过分类收集后，便于对不同类别进行专门处理，这不仅能极大提高资源的回收利用水平，更能有效减少最终需要处理的垃圾总量。</p>\r\n        </div>\r\n\r\n        <div class=\"benefits-grid\">\r\n            <!-- 卡片A: 减少占地 -->\r\n            <div class=\"benefit-card card-land\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/soil.png\" alt=\"[土地和绿芽图标]\">\r\n                <h2>A. 减少土地占用</h2>\r\n                <p>通过分类，我们可以筛选出可回收和不易降解的物质，使需要填埋的垃圾数量减少超过50%，极大地节约了宝贵的土地资源。</p>\r\n            </div>\r\n\r\n            <!-- 卡片B: 减少环境污染 -->\r\n            <div class=\"benefit-card card-pollution\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/planet-earth.png\" alt=\"[保护地球图标]\">\r\n                <h2>B. 减少环境污染</h2>\r\n                <p>废旧电池、灯管等含有汞等有毒重金属，直接填埋会严重污染土壤和水源。回收利用这些有害垃圾，是保护我们生态环境的关键一步。</p>\r\n            </div>\r\n\r\n            <!-- 卡片C: 变废为宝 -->\r\n            <div class=\"benefit-card card-treasure\">\r\n                <img src=\"https://img.icons8.com/plasticine/100/000000/recycling.png\" alt=\"[回收利用图标]\">\r\n                <h2>C. 实现资源再生</h2>\r\n                <p>每回收1吨废塑料，就能回炼约600公斤汽油；每回收1500吨废纸，就等于保护了用于生产1200吨新纸的森林。垃圾是放错地方的宝藏！</p>\r\n            </div>\r\n        </div>\r\n\r\n    </div>\r\n\r\n</body>\r\n</html>\r\n', 8, '2025-06-19 09:46:52', 3, 'published', NULL);
INSERT INTO `knowledgearticles` VALUES (9, '垃圾分类全攻略', '<!DOCTYPE html>\r\n<html lang=\"zh-CN\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;700&display=swap\" rel=\"stylesheet\">\r\n    <style>\r\n        /* --- 全局样式 --- */\r\n        .article-container {\r\n            font-family: \'Noto Sans SC\', sans-serif;\r\n            line-height: 1.8;\r\n            color: #333;\r\n            background-color: #f9fafb;\r\n            padding: 20px;\r\n        }\r\n        .section-title {\r\n            text-align: center;\r\n            font-size: 28px;\r\n            margin: 40px 0 20px 0;\r\n            font-weight: 700;\r\n        }\r\n        .section-divider {\r\n            border: 0;\r\n            height: 1px;\r\n            background-image: linear-gradient(to right, rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.15), rgba(0, 0, 0, 0));\r\n            margin: 60px 0;\r\n        }\r\n\r\n        /* --- 四大分类 --- */\r\n        .category-intro {\r\n            text-align: center;\r\n            margin-bottom: 30px;\r\n        }\r\n        .category-intro img {\r\n            max-width: 100%;\r\n            height: auto;\r\n            max-height: 120px;\r\n            margin-top: 10px;\r\n        }\r\n        .category-grid {\r\n            display: grid;\r\n            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));\r\n            gap: 25px;\r\n        }\r\n        .category-card {\r\n            background: #fff;\r\n            border-radius: 12px;\r\n            padding: 25px;\r\n            box-shadow: 0 4px 15px rgba(0,0,0,0.05);\r\n            border-left: 6px solid;\r\n        }\r\n        .category-card h3 {\r\n            font-size: 22px;\r\n            margin-top: 0;\r\n        }\r\n        .category-card ul {\r\n            padding-left: 20px;\r\n            color: #555;\r\n        }\r\n        .card-recyclable { border-color: #007bff; }\r\n        .card-kitchen { border-color: #28a745; }\r\n        .card-hazardous { border-color: #dc3545; }\r\n        .card-other { border-color: #6c757d; }\r\n\r\n        /* --- 常见误区 --- */\r\n        .misconception-list {\r\n            list-style: none;\r\n            padding: 0;\r\n        }\r\n        .misconception-item {\r\n            background: #fff;\r\n            border-radius: 10px;\r\n            padding: 20px;\r\n            margin-bottom: 15px;\r\n            box-shadow: 0 2px 8px rgba(0,0,0,0.05);\r\n            display: flex;\r\n            align-items: flex-start;\r\n        }\r\n        .misconception-item .icon {\r\n            font-size: 24px;\r\n            margin-right: 15px;\r\n        }\r\n        .misconception-item .content p {\r\n            margin: 0;\r\n        }\r\n        .misconception-item .myth {\r\n            color: #dc3545;\r\n            font-weight: bold;\r\n        }\r\n        .misconception-item .fact {\r\n            color: #28a745;\r\n            margin-top: 8px;\r\n        }\r\n\r\n        /* --- 问答部分 --- */\r\n        .faq-section details {\r\n            background: #fff;\r\n            border-radius: 10px;\r\n            margin-bottom: 10px;\r\n            padding: 15px 20px;\r\n            box-shadow: 0 2px 8px rgba(0,0,0,0.05);\r\n        }\r\n        .faq-section summary {\r\n            font-weight: bold;\r\n            font-size: 18px;\r\n            cursor: pointer;\r\n            list-style: none; /* 移除默认的三角箭头 */\r\n        }\r\n        .faq-section summary::-webkit-details-marker {\r\n            display: none; /* 移除默认的三角箭头 (Chrome/Safari) */\r\n        }\r\n        .faq-section summary::before {\r\n            content: \'►\';\r\n            margin-right: 10px;\r\n            font-size: 14px;\r\n            color: #007bff;\r\n            display: inline-block;\r\n            transition: transform 0.2s;\r\n        }\r\n        .faq-section details[open] summary::before {\r\n            transform: rotate(90deg);\r\n        }\r\n        .faq-section .answer {\r\n            padding-top: 15px;\r\n            margin-top: 15px;\r\n            border-top: 1px solid #eee;\r\n            color: #555;\r\n        }\r\n\r\n    </style>\r\n</head>\r\n<body>\r\n\r\n<div class=\"article-container\">\r\n\r\n    <h2 class=\"section-title\">一、四大分类</h2>\r\n    <div class=\"category-intro\">\r\n        <p>目前中国生活垃圾一般可分为四大类：<strong>可回收垃圾、厨余垃圾、有害垃圾</strong>和<strong>其他垃圾</strong>。</p>\r\n        <img src=\"https://placehold.co/800x150/FFFFFF/333333?text=可回收物%20%7C%20厨余垃圾%20%7C%20有害垃圾%20%7C%20其他垃圾\" alt=\"[垃圾分类标识图]\">\r\n    </div>\r\n\r\n    <div class=\"category-grid\">\r\n        <div class=\"category-card card-recyclable\">\r\n            <h3>1. 可回收物</h3>\r\n            <p>指回收后经过再加工可以成为生产原料或者经过整理可以再利用的物品。</p>\r\n            <ul>\r\n                <li><b>废纸类:</b> 报纸、纸箱、图书、干净纸张、利乐包装等。</li>\r\n                <li><b>塑料类:</b> 塑料饮料瓶、塑料油桶、塑料盆(盒)等。</li>\r\n                <li><b>玻璃类:</b> 玻璃瓶、平板玻璃、镜子等。</li>\r\n                <li><b>金属类:</b> 易拉罐、金属厨具、其他民用金属制品。</li>\r\n                <li><b>电子废弃物类:</b> 各类家用电器产品。</li>\r\n                <li><b>织物类:</b> 桌布、衣服、书包等。</li>\r\n            </ul>\r\n        </div>\r\n\r\n        <div class=\"category-card card-kitchen\">\r\n            <h3>2. 厨余垃圾 (湿垃圾)</h3>\r\n            <p>指家庭生活饮食中产生的有机垃圾，通俗讲就是容易腐烂的生物质废弃物。</p>\r\n            <ul>\r\n                <li><b>熟厨余:</b> 剩菜、剩饭、菜叶等。</li>\r\n                <li><b>生厨余:</b> 果皮、蛋壳、茶渣、骨头、贝壳等。</li>\r\n                <li><b>广义厨余:</b> 还包括用过的筷子、食品的包装材料等。</li>\r\n            </ul>\r\n        </div>\r\n        \r\n        <div class=\"category-card card-hazardous\">\r\n            <h3>3. 有害垃圾</h3>\r\n            <p>指存有对人体健康或自然环境造成直接或潜在危害的废弃物。</p>\r\n            <ul>\r\n                <li><b>日化用品:</b> 废药品、废化妆品。</li>\r\n                <li><b>电池灯管:</b> 充电电池、纽扣电池、废荧光灯管。</li>\r\n                <li><b>化学品:</b> 废杀虫剂、废消毒剂、废油漆、废溶剂。</li>\r\n                <li><b>其他:</b> 废温度计、废血压计等。</li>\r\n            </ul>\r\n        </div>\r\n\r\n        <div class=\"category-card card-other\">\r\n            <h3>4. 其他垃圾 (干垃圾)</h3>\r\n            <p>指除上述几类垃圾之外难以回收的废弃物，通常采取焚烧或者填埋的方式处理。</p>\r\n            <ul>\r\n                <li><b>污染纸张:</b> 使用过的卫生纸、餐巾纸、婴儿纸尿布。</li>\r\n                <li><b>难回收物:</b> 烟蒂、陶瓷制品、尘土。</li>\r\n                <li><b>其他:</b> 塑料光面废纸、木质玩具、橡胶制品等。</li>\r\n            </ul>\r\n        </div>\r\n    </div>\r\n\r\n    <hr class=\"section-divider\">\r\n\r\n    <h2 class=\"section-title\">二、垃圾分类小误区</h2>\r\n    <ul class=\"misconception-list\">\r\n        <li class=\"misconception-item\">\r\n            <span class=\"icon\">❌</span>\r\n            <div class=\"content\">\r\n                <p class=\"myth\">误区：大棒骨是厨余垃圾。</p>\r\n                <p class=\"fact\">真相：大棒骨因难腐蚀，应投入“其他垃圾”。</p>\r\n            </div>\r\n        </li>\r\n        <li class=\"misconception-item\">\r\n            <span class=\"icon\">❌</span>\r\n            <div class=\"content\">\r\n                <p class=\"myth\">误区：厕纸是纸，可回收。</p>\r\n                <p class=\"fact\">真相：厕纸遇水即溶，不具回收价值，属于“其他垃圾”。</p>\r\n            </div>\r\n        </li>\r\n        <li class=\"misconception-item\">\r\n            <span class=\"icon\">❌</span>\r\n            <div class=\"content\">\r\n                <p class=\"myth\">误区：用塑料袋装着厨余垃圾一起扔。</p>\r\n                <p class=\"fact\">真相：应将厨余垃圾倒入桶内，塑料袋本身另投进“可回收物”桶。</p>\r\n            </div>\r\n        </li>\r\n         <li class=\"misconception-item\">\r\n            <span class=\"icon\">❌</span>\r\n            <div class=\"content\">\r\n                <p class=\"myth\">误区：吃完的花生壳算其他垃圾。</p>\r\n                <p class=\"fact\">真相：花生壳、瓜子壳等坚果壳属于“厨余垃圾”。</p>\r\n            </div>\r\n        </li>\r\n        <li class=\"misconception-item\">\r\n            <span class=\"icon\">❌</span>\r\n            <div class=\"content\">\r\n                <p class=\"myth\">误区：热水瓶胆和灯管一样，是有害垃圾。</p>\r\n                <p class=\"fact\">真相：热水瓶胆主要是玻璃，仅有一层极薄的水银，应划为“其他垃圾”。</p>\r\n            </div>\r\n        </li>\r\n    </ul>\r\n\r\n    <hr class=\"section-divider\">\r\n\r\n    <h2 class=\"section-title\">三、你提问我回答</h2>\r\n    <div class=\"faq-section\">\r\n        <details>\r\n            <summary>1. 为什么要提倡垃圾分类?</summary>\r\n            <div class=\"answer\">\r\n                <p><b>① 破解“垃圾围城”：</b>中国正面临严峻的“垃圾围城”问题，多数城市已无地可填。分类是解决问题的根本出路。</p>\r\n                <p><b>② 遵循3R原则：</b>分类是实现垃圾处理3R原则——减量(Reduce)、复用(Reuse)、回收(Recycle)——的第一步，也是最重要的一步。</p>\r\n                <p><b>③ 借鉴成功经验：</b>德国、日本等发达国家和地区的成功实践证明，完备的垃圾分类体系是城市可持续发展的基石。</p>\r\n            </div>\r\n        </details>\r\n        <details>\r\n            <summary>2. 垃圾分类为什么从可再生资源回收着手?</summary>\r\n            <div class=\"answer\">\r\n                <p><b>① 经济价值巨大：</b>垃圾中的可再生资源若能回收利用，每年可创造数千亿元的产值。</p>\r\n                <p><b>② 激励民众参与：</b>从有经济价值的可再生资源入手，可以通过经济激励（如卖废品、积分兑换）有效提高居民参与垃圾分类的积极性。</p>\r\n                <p><b>③ 推动产业发展：</b>回收的可再生资源能为相关企业成功“造血”，形成良性循环的环保产业链。</p>\r\n            </div>\r\n        </details>\r\n        <details>\r\n            <summary>3. 参与垃圾分类我能得到什么?</summary>\r\n            <div class=\"answer\">\r\n                <p><b>① 履行公民责任：</b>爱护环境，人人有责。参与垃圾分类是我们作为地球公民保护家园最直接、最有效的行动。</p>\r\n                <p><b>② 汇聚社会力量：</b>“聚沙成塔”，每个人的微小努力汇聚起来，将共同推动“美丽中国”建设大步前进。</p>\r\n                <p><b>③ 共享发展红利：</b>推行垃圾分类产生的良好生态效益、社会效益和经济效益，最终将惠及我们每一个人。</p>\r\n            </div>\r\n        </details>\r\n    </div>\r\n\r\n</div>\r\n\r\n</body>\r\n</html>\r\n', 8, '2025-06-19 09:49:37', 6, 'published', NULL);
INSERT INTO `knowledgearticles` VALUES (10, '垃圾分类 | 垃圾分类小知识你知多少？', '<!DOCTYPE html>\r\n<html lang=\"zh-CN\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <!-- 引入一个外部字体，让页面更好看 -->\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap\" rel=\"stylesheet\">\r\n    <!-- 引入一个动画库，增加趣味性 -->\r\n    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css\"/>\r\n    <style>\r\n        /* --- 全局样式 --- */\r\n        .article-container {\r\n            font-family: \'Noto Sans SC\', sans-serif;\r\n            line-height: 1.9;\r\n            color: #4A4A4A;\r\n            background-color: #fdfdfd;\r\n        }\r\n\r\n        /* --- 引言部分 --- */\r\n        .intro-section {\r\n            background: linear-gradient(135deg, #4facfe, #00f2fe);\r\n            color: white;\r\n            padding: 60px 20px;\r\n            text-align: center;\r\n        }\r\n        .intro-section h1 {\r\n            font-size: 36px;\r\n            font-weight: 700;\r\n            margin: 0;\r\n            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);\r\n        }\r\n        .intro-section p {\r\n            font-size: 18px;\r\n            max-width: 700px;\r\n            margin: 15px auto 0 auto;\r\n            opacity: 0.9;\r\n        }\r\n\r\n        /* --- 步骤/问答部分 --- */\r\n        .step-section {\r\n            max-width: 900px;\r\n            margin: 50px auto;\r\n            padding: 20px;\r\n        }\r\n        .step {\r\n            display: flex;\r\n            align-items: flex-start;\r\n            margin-bottom: 50px;\r\n        }\r\n        .step-number {\r\n            font-size: 48px;\r\n            font-weight: 700;\r\n            color: #e0e0e0;\r\n            line-height: 1;\r\n            margin-right: 25px;\r\n        }\r\n        .step-content {\r\n            flex: 1;\r\n        }\r\n        .step-content h2 {\r\n            font-size: 26px;\r\n            font-weight: 700;\r\n            margin-top: 5px;\r\n            margin-bottom: 15px;\r\n            border-bottom: 3px solid #007bff;\r\n            padding-bottom: 8px;\r\n            display: inline-block;\r\n        }\r\n        \r\n        /* 好处列表 */\r\n        .benefits-list {\r\n            list-style: none;\r\n            padding-left: 0;\r\n        }\r\n        .benefits-list li {\r\n            background: #f8f9fa;\r\n            border-left: 4px solid #007bff;\r\n            padding: 15px;\r\n            margin-bottom: 10px;\r\n            border-radius: 0 8px 8px 0;\r\n        }\r\n        \r\n        /* 分类网格 */\r\n        .category-grid {\r\n            display: grid;\r\n            grid-template-columns: 1fr 1fr;\r\n            gap: 20px;\r\n        }\r\n        .category-item {\r\n            padding: 15px;\r\n            border-radius: 8px;\r\n            background-color: #f8f9fa;\r\n        }\r\n        .category-item strong {\r\n            display: block;\r\n            margin-bottom: 5px;\r\n            font-size: 18px;\r\n        }\r\n        .cat-recyclable { color: #007bff; }\r\n        .cat-kitchen { color: #28a745; }\r\n        .cat-hazardous { color: #dc3545; }\r\n        .cat-other { color: #6c757d; }\r\n        \r\n        /* 顺口溜 */\r\n        .slogan {\r\n            background-color: #fff3cd;\r\n            border: 1px solid #ffeeba;\r\n            color: #856404;\r\n            padding: 20px;\r\n            border-radius: 8px;\r\n            text-align: center;\r\n            font-size: 1.2em;\r\n            font-weight: 500;\r\n        }\r\n\r\n        /* 结尾 */\r\n        .conclusion {\r\n            text-align: center;\r\n            font-size: 1.1em;\r\n            color: #555;\r\n            margin-top: 30px;\r\n        }\r\n\r\n    </style>\r\n</head>\r\n<body class=\"article-container\">\r\n\r\n    <div class=\"intro-section animate__animated animate__fadeIn\">\r\n        <h1>开启绿色生活：垃圾分类全攻略</h1>\r\n        <p>我们在生产、生活中产生的大量垃圾，正在严重侵蚀我们的生存环境。垃圾分类是实现垃圾减量化、资源化、无害化，避免“垃圾围城”的有效途径。今天就让我们一起来深入学习一下吧！</p>\r\n    </div>\r\n\r\n    <div class=\"step-section\">\r\n        <!-- 第1步 -->\r\n        <div class=\"step animate__animated animate__fadeInUp\">\r\n            <div class=\"step-number\">01</div>\r\n            <div class=\"step-content\">\r\n                <h2>什么是垃圾分类？</h2>\r\n                <p>垃圾分类是按规定将垃圾分类储存、分类投放和搬运，从而转变成公共资源的一系列活动的总称。</p>\r\n            </div>\r\n        </div>\r\n\r\n        <!-- 第2步 -->\r\n        <div class=\"step animate__animated animate__fadeInUp\">\r\n            <div class=\"step-number\">02</div>\r\n            <div class=\"step-content\">\r\n                <h2>为什么要垃圾分类？</h2>\r\n                <p>垃圾通过分类收集后，便于对不同类垃圾进行分类处置，既提高垃圾资源利用水平，又可减少垃圾处置量。主要有三大好处：</p>\r\n                <ul class=\"benefits-list\">\r\n                    <li><strong>减少占地：</strong>通过分类，可回收与不易降解的物质被分离，能使垃圾总量减少50%以上。</li>\r\n                    <li><strong>减少环境污染：</strong>回收废电池等有害垃圾，可以避免其中的汞等有毒物质污染土壤和水源，保护我们的健康。</li>\r\n                    <li><strong>变废为宝：</strong>1吨废塑料可回炼600公斤汽油；1500吨废纸可免于砍伐大片森林。垃圾是放错地方的资源。</li>\r\n                </ul>\r\n            </div>\r\n        </div>\r\n\r\n        <!-- 第3步 -->\r\n        <div class=\"step animate__animated animate__fadeInUp\">\r\n            <div class=\"step-number\">03</div>\r\n            <div class=\"step-content\">\r\n                <h2>垃圾分几类？</h2>\r\n                <p>我国城市生活垃圾一般分类以下四类：</p>\r\n                <div class=\"category-grid\">\r\n                    <div class=\"category-item\">\r\n                        <strong class=\"cat-recyclable\">可回收垃圾：</strong>主要包括废纸、塑料、玻璃、金属和布料五类，可回收循环利用。\r\n                    </div>\r\n                    <div class=\"category-item\">\r\n                        <strong class=\"cat-kitchen\">厨余垃圾：</strong>菜叶、果皮、剩饭剩菜等为主，一般采用集中堆肥方式处理。\r\n                    </div>\r\n                    <div class=\"category-item\">\r\n                        <strong class=\"cat-hazardous\">有害垃圾：</strong>包括废电池、废灯管、过期药品等，需要经过特殊处理，防止污染环境。\r\n                    </div>\r\n                    <div class=\"category-item\">\r\n                        <strong class=\"cat-other\">其他垃圾：</strong>除上述几类垃圾以外的难以回收的废弃物，一般采用卫生填埋处理。\r\n                    </div>\r\n                </div>\r\n            </div>\r\n        </div>\r\n\r\n        <!-- 第4步 -->\r\n        <div class=\"step animate__animated animate__fadeInUp\">\r\n            <div class=\"step-number\">04</div>\r\n            <div class=\"step-content\">\r\n                <h2>如何垃圾分类？</h2>\r\n                <p>请大家记住下面这个顺口溜：</p>\r\n                <div class=\"slogan\">\r\n                    <p>生活垃圾四类分，对号投放不乱扔。</p>\r\n                </div>\r\n                <p class=\"conclusion\">垃圾分类看似小事，实则关系千家万户，需要我们每一个公民的积极参与和配合。每天多一分努力，文明就前进一步！</p>\r\n            </div>\r\n        </div>\r\n    </div>\r\n\r\n</body>\r\n</html>', 8, '2025-06-19 09:52:21', 7, 'published', NULL);
INSERT INTO `knowledgearticles` VALUES (11, '程序员的“头顶大事” ', '<!DOCTYPE html>\r\n<html lang=\"zh-CN\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <!-- 引入一个清晰的外部字体 -->\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap\" rel=\"stylesheet\">\r\n    <style>\r\n        /* --- 全局样式 --- */\r\n        .article-container {\r\n            font-family: \'Noto Sans SC\', sans-serif;\r\n            line-height: 1.8;\r\n            color: #343a40;\r\n            background-color: #f8f9fa;\r\n            padding: 20px;\r\n        }\r\n        .main-content {\r\n            max-width: 900px;\r\n            margin: 0 auto;\r\n            background-color: #fff;\r\n            padding: 40px;\r\n            border-radius: 12px;\r\n            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.05);\r\n        }\r\n\r\n        /* --- 头部引言 --- */\r\n        .article-header {\r\n            text-align: center;\r\n            margin-bottom: 40px;\r\n        }\r\n        .article-header h1 {\r\n            font-size: 32px;\r\n            font-weight: 700;\r\n            margin-bottom: 15px;\r\n            color: #212529;\r\n        }\r\n        .article-header p {\r\n            font-size: 18px;\r\n            color: #6c757d;\r\n            max-width: 700px;\r\n            margin: 0 auto;\r\n        }\r\n\r\n        /* --- 分区标题 --- */\r\n        .section-title {\r\n            font-size: 26px;\r\n            font-weight: 700;\r\n            margin: 50px 0 25px 0;\r\n            text-align: center;\r\n            position: relative;\r\n        }\r\n        .section-title::after {\r\n            content: \'\';\r\n            display: block;\r\n            width: 60px;\r\n            height: 3px;\r\n            background-color: #007bff;\r\n            margin: 10px auto 0 auto;\r\n            border-radius: 2px;\r\n        }\r\n\r\n        /* --- 卡片网格布局 --- */\r\n        .card-grid {\r\n            display: grid;\r\n            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));\r\n            gap: 25px;\r\n        }\r\n\r\n        /* --- 卡片样式 --- */\r\n        .info-card {\r\n            background-color: #fdfdfd;\r\n            border: 1px solid #e9ecef;\r\n            border-radius: 10px;\r\n            padding: 25px;\r\n            text-align: center;\r\n            transition: transform 0.3s ease, box-shadow 0.3s ease;\r\n        }\r\n        .info-card:hover {\r\n            transform: translateY(-5px);\r\n            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);\r\n        }\r\n        .info-card img {\r\n            width: 64px;\r\n            height: 64px;\r\n            margin-bottom: 15px;\r\n        }\r\n        .info-card h3 {\r\n            font-size: 20px;\r\n            margin: 0 0 10px 0;\r\n            color: #343a40;\r\n        }\r\n        .info-card p {\r\n            font-size: 15px;\r\n            color: #6c757d;\r\n            margin: 0;\r\n        }\r\n        \r\n        /* --- 结尾部分 --- */\r\n        .conclusion {\r\n            margin-top: 50px;\r\n            padding: 20px;\r\n            background-color: #e9f7ff;\r\n            border-left: 5px solid #007bff;\r\n            border-radius: 0 8px 8px 0;\r\n        }\r\n        .conclusion p {\r\n            margin: 0;\r\n            font-size: 1.1em;\r\n            color: #004085;\r\n        }\r\n    </style>\r\n</head>\r\n<body>\r\n\r\n<div class=\"article-container\">\r\n    <div class=\"main-content\">\r\n        <header class=\"article-header\">\r\n            <h1>聊聊程序员的“头顶大事”</h1>\r\n            <p>“秃头”是一个常见的调侃，但它不应成为评价个人能力的标准。让我们理性、科学地看待这个现象，并找到积极的应对方法。</p>\r\n        </header>\r\n\r\n        <section>\r\n            <h2 class=\"section-title\">现象背后的原因</h2>\r\n            <div class=\"card-grid\">\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/imac.png\" alt=\"[长时间使用电脑图标]\">\r\n                    <h3>长时间坐姿与用脑</h3>\r\n                    <p>久坐导致血液循环不畅，高强度脑力劳动增加精神压力，影响毛囊的营养供应。</p>\r\n                </div>\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/task.png\" alt=\"[高压工作图标]\">\r\n                    <h3>长期处于高压状态</h3>\r\n                    <p>面对复杂的编码问题和紧张的项目进度，身体激素可能失调，加速头发生长周期的改变。</p>\r\n                </div>\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/empty-bed.png\" alt=\"[缺乏休息图标]\">\r\n                    <h3>缺乏休息与放松</h3>\r\n                    <p>频繁加班和不规律的作息让身心持续疲劳，头皮和毛囊的健康也随之受到影响。</p>\r\n                </div>\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/dna-helix.png\" alt=\"[遗传因素图标]\">\r\n                    <h3>遗传因素</h3>\r\n                    <p>不可忽视的是，一部分人可能具有遗传性脱发倾向，这是重要的先天因素。</p>\r\n                </div>\r\n            </div>\r\n        </section>\r\n\r\n        <section>\r\n            <h2 class=\"section-title\">如何积极应对？</h2>\r\n            <div class=\"card-grid\">\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/spinach.png\" alt=\"[均衡饮食图标]\">\r\n                    <h3>均衡饮食</h3>\r\n                    <p>摄入足量的维生素、矿物质和蛋白质，为头发的健康生长提供坚实的营养基础。</p>\r\n                </div>\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/dumbbell.png\" alt=\"[定期锻炼图标]\">\r\n                    <h3>定期锻炼</h3>\r\n                    <p>增加身体的血液循环，不仅能强身健体，更能有效促进头皮和毛囊的营养供应。</p>\r\n                </div>\r\n                <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/sleeping-in-bed.png\" alt=\"[充足休息图标]\">\r\n                    <h3>注意休息与放松</h3>\r\n                    <p>避免过度工作和长期压力，学会劳逸结合，保持身心健康，给头发一个喘息的机会。</p>\r\n                </div>\r\n                 <div class=\"info-card\">\r\n                    <img src=\"https://img.icons8.com/plasticine/100/null/doctor-male.png\" alt=\"[咨询医生图标]\">\r\n                    <h3>科学求助</h3>\r\n                    <p>如有必要，可以咨询专业医生或皮肤科医生，了解更多关于脱发的预防和科学治疗方法。</p>\r\n                </div>\r\n            </div>\r\n        </section>\r\n\r\n        <div class=\"conclusion\">\r\n            <p><strong>核心观点：</strong>对于整个行业来说，程序员的“秃头”现象不应被过度夸大或歧视。它只是一个外在特征，代码的质量和逻辑的严谨才是衡量一位程序员专业素养的真正标准。</p>\r\n        </div>\r\n    </div>\r\n</div>\r\n\r\n</body>\r\n</html>\r\n', 8, '2025-06-19 09:56:32', 6, 'published', NULL);

-- ----------------------------
-- Table structure for quizquestions
-- ----------------------------
DROP TABLE IF EXISTS `quizquestions`;
CREATE TABLE `quizquestions`  (
  `question_id` int NOT NULL AUTO_INCREMENT COMMENT '题目唯一标识ID，主键',
  `game_id` int NOT NULL COMMENT '所属游戏ID，外键关联Games表 (且game_type=\'quiz\')',
  `question_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '问题描述文本',
  `option_a` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项A内容',
  `option_b` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项B内容',
  `option_c` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项C内容',
  `option_d` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '选项D内容 (可为空, 适用于3选1或4选1)',
  `correct_option` enum('A','B','C','D') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '正确答案选项',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '答案解析说明',
  `related_category_id` int NULL DEFAULT NULL COMMENT '题目关联的垃圾分类ID，外键关联VideoCategories表',
  `difficulty` enum('easy','medium','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'medium' COMMENT '题目难度级别',
  PRIMARY KEY (`question_id`) USING BTREE,
  INDEX `fk_QuizQuestions_Games_idx`(`game_id` ASC) USING BTREE,
  INDEX `fk_QuizQuestions_VideoCategories_idx`(`related_category_id` ASC) USING BTREE,
  CONSTRAINT `fk_QuizQuestions_Games` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_QuizQuestions_VideoCategories` FOREIGN KEY (`related_category_id`) REFERENCES `videocategories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '问答游戏题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of quizquestions
-- ----------------------------

-- ----------------------------
-- Table structure for recyclingitems
-- ----------------------------
DROP TABLE IF EXISTS `recyclingitems`;
CREATE TABLE `recyclingitems`  (
  `item_id` int NOT NULL AUTO_INCREMENT COMMENT '物品唯一标识ID',
  `user_id` int NOT NULL COMMENT '发布用户ID, 外键关联Users表',
  `item_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品名称',
  `item_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '物品详细描述',
  `photo_urls` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '物品照片路径 (可存储为JSON数组或逗号分隔的字符串)',
  `wanted_items` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '希望交换的物品描述',
  `contact_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系方式 (微信/QQ/电话)',
  `status` enum('available','exchanged') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'available' COMMENT '物品状态 (可交换, 已换出)',
  `posted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布日期时间',
  PRIMARY KEY (`item_id`) USING BTREE,
  INDEX `fk_RecyclingItems_Users_idx`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_RecyclingItems_Users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '旧物利用物品信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recyclingitems
-- ----------------------------

-- ----------------------------
-- Table structure for recyclingpoints
-- ----------------------------
DROP TABLE IF EXISTS `recyclingpoints`;
CREATE TABLE `recyclingpoints`  (
  `point_id` int NOT NULL AUTO_INCREMENT COMMENT '回收/捐赠点唯一标识ID，主键',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '回收点/渠道名称',
  `type` enum('recycling_station','donation_point','exchange_info') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '信息类型 (回收站, 捐赠点, 交换信息)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '详细描述信息',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址',
  `contact_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系方式 (电话, 微信等)',
  `acceptable_items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '可接受的物品类型列表 (可存储为JSON数组字符串或逗号分隔的字符串)',
  `region_id` int NULL DEFAULT NULL COMMENT '所属地区ID，外键关联Regions表',
  `publisher_id` int NOT NULL COMMENT '信息发布者ID，外键关联Users表 (通常是admin或认证用户)',
  `verified_status` enum('pending','verified','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending' COMMENT '信息审核状态 (待审核, 已验证, 已拒绝)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '信息创建日期时间',
  `latitude` decimal(10, 8) NULL DEFAULT NULL COMMENT '回收点/渠道的纬度 (用于地图展示)',
  `longitude` decimal(11, 8) NULL DEFAULT NULL COMMENT '回收点/渠道的经度 (用于地图展示)',
  PRIMARY KEY (`point_id`) USING BTREE,
  INDEX `fk_RecyclingPoints_Regions_idx`(`region_id` ASC) USING BTREE,
  INDEX `fk_RecyclingPoints_Users_idx`(`publisher_id` ASC) USING BTREE,
  CONSTRAINT `fk_RecyclingPoints_Regions` FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_RecyclingPoints_Users` FOREIGN KEY (`publisher_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '旧物回收/捐赠信息平台表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recyclingpoints
-- ----------------------------

-- ----------------------------
-- Table structure for regions
-- ----------------------------
DROP TABLE IF EXISTS `regions`;
CREATE TABLE `regions`  (
  `region_id` int NOT NULL AUTO_INCREMENT COMMENT '地区唯一标识ID，主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地区名称 (如: 北京市, 上海市)',
  `sorting_standard_summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '该地区垃圾分类标准摘要或特殊说明',
  PRIMARY KEY (`region_id`) USING BTREE,
  UNIQUE INDEX `name_UNIQUE`(`name` ASC) USING BTREE COMMENT '地区名称唯一'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '地区信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of regions
-- ----------------------------

-- ----------------------------
-- Table structure for user_historical_avatars
-- ----------------------------
DROP TABLE IF EXISTS `user_historical_avatars`;
CREATE TABLE `user_historical_avatars`  (
  `user_id` int NOT NULL,
  `avatar1_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar2_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar3_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  CONSTRAINT `fk_user_historical` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_historical_avatars
-- ----------------------------
INSERT INTO `user_historical_avatars` VALUES (4, NULL, NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (5, 'uploads/avatars/62ad7ba5-b67c-4859-99b1-6c2583c4153f.jpg', NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (7, NULL, NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (8, 'uploads/avatars/267fd6c1-a045-4ff7-9423-d7b14cc70ea4.jpg', NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (9, NULL, NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (10, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for usergamescores
-- ----------------------------
DROP TABLE IF EXISTS `usergamescores`;
CREATE TABLE `usergamescores`  (
  `score_id` int NOT NULL AUTO_INCREMENT COMMENT '得分记录唯一标识ID，主键',
  `user_id` int NOT NULL COMMENT '用户ID，外键关联Users表',
  `game_id` int NOT NULL COMMENT '游戏ID，外键关联Games表',
  `score` int NOT NULL COMMENT '用户在该局游戏中获得的分数',
  `played_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '游戏进行的日期时间',
  `duration_seconds` int NULL DEFAULT NULL COMMENT '游戏所用时长，单位：秒 (可为空)',
  PRIMARY KEY (`score_id`) USING BTREE,
  INDEX `fk_UserGameScores_Users_idx`(`user_id` ASC) USING BTREE,
  INDEX `fk_UserGameScores_Games_idx`(`game_id` ASC) USING BTREE,
  CONSTRAINT `fk_UserGameScores_Games` FOREIGN KEY (`game_id`) REFERENCES `games` (`game_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_UserGameScores_Users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户游戏得分记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usergamescores
-- ----------------------------
INSERT INTO `usergamescores` VALUES (1, 7, 1, 14, '2025-06-18 22:15:13', 151);
INSERT INTO `usergamescores` VALUES (2, 8, 1, 5, '2025-06-19 14:09:06', 99);
INSERT INTO `usergamescores` VALUES (3, 10, 1, 3, '2025-06-19 15:20:30', 95);
INSERT INTO `usergamescores` VALUES (4, 9, 1, 12, '2025-06-19 15:21:27', 112);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识ID，主键',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录用户名，唯一',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '加盐哈希后的密码',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户邮箱，唯一，可为空',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `age_group` enum('child','teenager','adult','senior') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '年龄段，用于内容推荐',
  `region_id` int NULL DEFAULT NULL COMMENT '用户所属地区ID，外键关联Regions表',
  `role` enum('user','admin','editor') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT '用户角色 (普通用户, 管理员, 编辑)',
  `registration_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '用户注册日期时间',
  `last_login_date` timestamp NULL DEFAULT NULL COMMENT '用户最后登录日期时间',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '账户是否激活 (1:激活, 0:禁用)',
  `current_avatar_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username_UNIQUE`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email_UNIQUE`(`email` ASC) USING BTREE,
  INDEX `fk_Users_Regions_idx`(`region_id` ASC) USING BTREE,
  CONSTRAINT `fk_Users_Regions` FOREIGN KEY (`region_id`) REFERENCES `regions` (`region_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, '123', '$2a$10$anJQ3y2OjsP24ZAAFlHuceLDhntUv2vXkUpILnj0YDnulOQ9xHZV2', NULL, '', NULL, NULL, 'user', '2025-05-15 11:35:53', '2025-05-26 19:54:26', 1, NULL);
INSERT INTO `users` VALUES (4, '666', '$2a$10$4Lq8.Lr/4qzasf5ykAkkVuLtLItIgWYEqrK4/EsW7bjbfOCanoQ4W', NULL, 'zh', NULL, NULL, 'user', '2025-05-26 11:46:52', '2025-05-26 19:50:18', 1, 'uploads/avatars/f86bd7b7-d842-4c76-b0d9-576ae85e20bd.jpg');
INSERT INTO `users` VALUES (5, '222', '$2a$10$3Wa2MqKJ0WsyUzZoEX3GReBbYrRUoeSNB6yw4P1laCDMvb52FEJry', NULL, '', NULL, NULL, 'user', '2025-05-26 11:55:07', '2025-05-26 20:52:59', 1, 'uploads/avatars/user5_c7b68cf5.jpg');
INSERT INTO `users` VALUES (7, 'www', '$2a$10$wUtUxqkUKW9.f/LEkW7dUe36b9BMPnAnB8/VnW81fjWNqM2505jdm', NULL, 'w', 'teenager', NULL, 'user', '2025-06-18 13:51:26', '2025-06-18 22:12:38', 1, 'uploads/avatars/54747ccb-1b20-4101-b694-cc20ed4785e2.jpg');
INSERT INTO `users` VALUES (8, 'admin', '$2a$10$NBX.yScS84Wb22F6/i7z/.5nPnvu5s8BbwawTclzTWWzFAMPfBEoK', NULL, 'admin', 'teenager', NULL, 'admin', '2025-06-18 15:39:34', '2025-06-19 20:35:26', 1, 'uploads/avatars/user8_c56a9cfe.png');
INSERT INTO `users` VALUES (9, 'admin1', '$2a$10$u0TABNXy5kYqDEV.ElBBXuBvbTxlyp3nxyTkwWzkMrOLJ43ikXPq2', '2123242582@qq.com', '123456', 'child', NULL, 'admin', '2025-06-19 07:03:08', '2025-06-19 15:03:19', 1, NULL);
INSERT INTO `users` VALUES (10, '18053954841', '$2a$10$QrVSmCEUZah1Nj0RFs76ROiwXgkojyveZSi7ju3HZouxjkTXRLB3O', '3274256736@qq.com', '爸爸', 'senior', NULL, 'admin', '2025-06-19 07:17:48', '2025-06-19 17:58:27', 1, 'uploads/avatars/b6f1d03d-72fe-4892-b652-e02ef1850364.jpg');

-- ----------------------------
-- Table structure for video_category_mapping
-- ----------------------------
DROP TABLE IF EXISTS `video_category_mapping`;
CREATE TABLE `video_category_mapping`  (
  `video_id` int NOT NULL COMMENT '视频ID，外键关联Videos表',
  `category_id` int NOT NULL COMMENT '分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`video_id`, `category_id`) USING BTREE,
  INDEX `fk_Video_Category_Mapping_VideoCategories_idx`(`category_id` ASC) USING BTREE,
  INDEX `fk_Video_Category_Mapping_Videos_idx`(`video_id` ASC) USING BTREE,
  CONSTRAINT `fk_Video_Category_Mapping_VideoCategories` FOREIGN KEY (`category_id`) REFERENCES `videocategories` (`category_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Video_Category_Mapping_Videos` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '视频与分类的关联映射表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of video_category_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for videocategories
-- ----------------------------
DROP TABLE IF EXISTS `videocategories`;
CREATE TABLE `videocategories`  (
  `category_id` int NOT NULL AUTO_INCREMENT COMMENT '分类唯一标识ID，主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称 (如: 可回收物, 有害垃圾)',
  `icon_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类图标的URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '分类的详细描述',
  PRIMARY KEY (`category_id`) USING BTREE,
  UNIQUE INDEX `name_UNIQUE`(`name` ASC) USING BTREE COMMENT '分类名称唯一'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '视频/垃圾主分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of videocategories
-- ----------------------------

-- ----------------------------
-- Table structure for videos
-- ----------------------------
DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos`  (
  `video_id` int NOT NULL AUTO_INCREMENT COMMENT '视频唯一标识ID，主键',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '视频内容描述',
  `video_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '视频文件的存储路径或URL',
  `thumbnail_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频缩略图的URL',
  `duration_seconds` int NULL DEFAULT NULL COMMENT '视频时长，单位：秒',
  `uploader_id` int NULL DEFAULT NULL COMMENT '视频上传者ID，外键关联Users表 (通常是admin或editor)',
  `views_count` int NULL DEFAULT 0 COMMENT '视频被观看的次数',
  `likes_count` int NULL DEFAULT 0 COMMENT '视频被点赞的次数',
  `publish_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '视频发布日期时间',
  `status` enum('pending','published','archived') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending' COMMENT '视频状态 (待审核, 已发布, 已归档)',
  `suitable_age_groups` set('child','teenager','adult','senior') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频适宜的年龄段 (可多选)',
  `primary_category_id` int NULL DEFAULT NULL COMMENT '视频所属的主要分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`video_id`) USING BTREE,
  INDEX `fk_Videos_Users_idx`(`uploader_id` ASC) USING BTREE,
  INDEX `fk_Videos_VideoCategories_idx`(`primary_category_id` ASC) USING BTREE,
  CONSTRAINT `fk_Videos_Users` FOREIGN KEY (`uploader_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_Videos_VideoCategories` FOREIGN KEY (`primary_category_id`) REFERENCES `videocategories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教育视频信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of videos
-- ----------------------------
INSERT INTO `videos` VALUES (1, '黑马程序员软件测试视频教程，软件测试基础入门到项目实战', '传智教育·黑马程序员软件测试研究院全新录制的软件测试入门教程\r\n全部配套资源领取方式：关注黑马程序员公众号，回复关键词:领取资源02\r\n===============================\r\n课程内容：\r\n1、软件测试基础\r\n2、测试设计\r\n3、缺陷管理\r\n4、Web常用标签\r\n5、项目实战\r\n以终为始，由交付实战目标为终，推出所学知识；从认识软件及软件测试，到如何设计测试、缺陷标准及缺陷管理，最终以项目实战贯穿所学知识，让知识与应用相结合。\r\n===============================\r\n本教程学完请继续下一课程：Linux系统BV11t411M7uZ', '//player.bilibili.com/player.html?isOutside=true&aid=893108732&bvid=BV1TP4y1J7BD&cid=1597770412&p=1', '', NULL, 8, 0, 0, '2025-06-18 16:26:35', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (2, '垃圾分类', '', 'https://v.qq.com/txp/iframe/player.html?vid=g3573hlbzlr', '', NULL, 8, 0, 0, '2025-06-18 16:57:02', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (3, '【科普动画】你肯定知道垃圾该如何分类，但你知道垃圾分类后都去了哪里吗？', '“垃圾分类”几乎成了全国性的热点话题，可你又记住了多少呢？有没有一种既有趣又能帮孩子彻底搞定垃圾分类的方法呢？！当然有，做儿童通识教育的好奇动物联合做儿童智能推车的小木马给大家带来了这么一节垃圾分类公益科普课程，通过5分钟的趣味卡通视频课程，让孩子彻底搞懂垃圾分类相关的知识。很快，垃圾分类政策会在全国范围内实施，不管是为了自己的口袋，还是为了更美好的地球，赶快给孩子播放吧~', '//player.bilibili.com/player.html?isOutside=true&aid=59691040&bvid=BV1gt41137Fy&cid=141306819&p=1', '', NULL, 8, 0, 0, '2025-06-19 05:56:18', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (4, '垃圾分类', '', '//player.bilibili.com/player.html?isOutside=true&aid=1253029695&bvid=BV1ZJ4m1V7QZ&cid=1502612421&p=1', '', NULL, 8, 0, 0, '2025-06-19 05:58:00', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (5, '3分钟回答你对垃圾分类的所有疑问', '现阶段推行的垃圾分类制度，将我们生活中的垃圾分为有害垃圾、可回收物、湿垃圾、干垃圾四大类。当我们将垃圾按类别投放至相应的垃圾收容器后，这些垃圾又将何去何从呢？', '//player.bilibili.com/player.html?isOutside=true&aid=57684826&bvid=BV1q4411w7s7&cid=100691709&p=1', '', NULL, 8, 0, 0, '2025-06-19 05:58:38', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (6, '【短片】大学生微视频比赛“传承的力量”《垃圾分类》', '2020年全国职业院校“传承的力量”微视频大赛（江苏赛区）高职比赛中/荣获二等奖\r\n\r\n拍摄设备：佳能(canon) EOS 800D 18~135mm\r\n剪辑：Adobe Premiere 2019\r\n音频处理：Audition', '//player.bilibili.com/player.html?isOutside=true&aid=542098422&bvid=BV1Wi4y1u76i&cid=233139973&p=1', '', NULL, 8, 0, 0, '2025-06-19 05:59:34', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (7, '小小的垃圾分类竟道出国人心声！', '', '//player.bilibili.com/player.html?isOutside=true&aid=57597164&bvid=BV1Rx411X7uD&cid=100545017&p=1', 'https://i2.hdslb.com/bfs/archive/c71cc9882429f1943da0061340d81515e5002938.jpg@672w_378h_1c_!web-search-common-cover.avif', NULL, 8, 0, 0, '2025-06-19 06:00:35', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (8, '生活中的垃圾去哪儿了？', '生活中的垃圾去哪儿了？让我们跟着网络达人“火车司机小维”的镜头，一起走进神秘的垃圾焚烧厂，近距离了解城市每日产生的巨量垃圾的最终“归宿”，一同见证城市背后这份不为人熟知的“清洁奇迹”！', '//player.bilibili.com/player.html?isOutside=true&aid=114447339232820&bvid=BV1kYVczdEy8&cid=29780020040&p=1', '', NULL, 8, 0, 0, '2025-06-19 06:04:29', 'published', NULL, NULL);
INSERT INTO `videos` VALUES (9, '伊朗变得越来越抽象', '', '//player.bilibili.com/player.html?isOutside=true&aid=114692118810501&bvid=BV14KMqzpEgv&cid=30526866319&p=1', '', NULL, 8, 0, 0, '2025-06-19 07:27:01', 'published', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
