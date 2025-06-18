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

 Date: 18/06/2025 23:49:21
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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '环境问题上报表 (\"随手拍\")' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of environmentalreports
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '知识文章表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of knowledgearticles
-- ----------------------------

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
INSERT INTO `user_historical_avatars` VALUES (6, 'uploads/avatars/user6_7386a527.jpg', 'uploads/avatars/user6_1926e3c6.jpg', 'uploads/avatars/99d4578f-9082-41fc-9ca8-7ddcb89ba472.jpg');
INSERT INTO `user_historical_avatars` VALUES (7, NULL, NULL, NULL);
INSERT INTO `user_historical_avatars` VALUES (8, NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户游戏得分记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usergamescores
-- ----------------------------
INSERT INTO `usergamescores` VALUES (1, 7, 1, 14, '2025-06-18 22:15:13', 151);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (2, 'zhh', '$2a$10$M2jqDq6nn.ckAKv9mU.xlu8K8MzybjTG38nDeJ7TF7S3W5DuWEFa6', '123456@mail.com', 'zhh', 'teenager', NULL, 'user', '2025-05-09 08:33:37', '2025-05-15 19:20:25', 1, NULL);
INSERT INTO `users` VALUES (3, '123', '$2a$10$anJQ3y2OjsP24ZAAFlHuceLDhntUv2vXkUpILnj0YDnulOQ9xHZV2', NULL, '', NULL, NULL, 'user', '2025-05-15 11:35:53', '2025-05-26 19:54:26', 1, NULL);
INSERT INTO `users` VALUES (4, '666', '$2a$10$4Lq8.Lr/4qzasf5ykAkkVuLtLItIgWYEqrK4/EsW7bjbfOCanoQ4W', NULL, 'zh', NULL, NULL, 'user', '2025-05-26 11:46:52', '2025-05-26 19:50:18', 1, 'uploads/avatars/f86bd7b7-d842-4c76-b0d9-576ae85e20bd.jpg');
INSERT INTO `users` VALUES (5, '222', '$2a$10$3Wa2MqKJ0WsyUzZoEX3GReBbYrRUoeSNB6yw4P1laCDMvb52FEJry', NULL, '', NULL, NULL, 'user', '2025-05-26 11:55:07', '2025-05-26 20:52:59', 1, 'uploads/avatars/user5_c7b68cf5.jpg');
INSERT INTO `users` VALUES (6, '333', '$2a$10$kZhz6psPxSsElII3zwc3NOMj1WJ3pIjtMeNnuqFekkwLGqUecElWu', NULL, '', NULL, NULL, 'user', '2025-05-26 13:43:49', '2025-05-26 21:43:56', 1, 'uploads/avatars/user6_00efad0b.jpg');
INSERT INTO `users` VALUES (7, 'www', '$2a$10$wUtUxqkUKW9.f/LEkW7dUe36b9BMPnAnB8/VnW81fjWNqM2505jdm', NULL, 'w', 'teenager', NULL, 'user', '2025-06-18 13:51:26', '2025-06-18 22:12:38', 1, 'uploads/avatars/54747ccb-1b20-4101-b694-cc20ed4785e2.jpg');
INSERT INTO `users` VALUES (8, 'admin', '$2a$10$NBX.yScS84Wb22F6/i7z/.5nPnvu5s8BbwawTclzTWWzFAMPfBEoK', NULL, 'admin', 'teenager', NULL, 'admin', '2025-06-18 15:39:34', '2025-06-18 23:44:58', 1, 'uploads/avatars/267fd6c1-a045-4ff7-9423-d7b14cc70ea4.jpg');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教育视频信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of videos
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
