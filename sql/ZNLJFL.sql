-- -----------------------------------------------------
-- SQL Script for Smart Waste Sorting Education Platform Database
-- Database Name: ZNLJFL (智能垃圾分类)
-- File Name: ZNLJFL.sql
-- Date: 2023-10-27
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ZNLJFL
-- 描述: 智能垃圾分类教育平台数据库 (ZNLJFL 是 “智能垃圾分类” 的拼音首字母缩写)
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ZNLJFL` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `ZNLJFL` ;

-- -----------------------------------------------------
-- Table `ZNLJFL`.`Regions`
-- 描述: 存储地区信息，用于用户归属地、上报事件地点、回收点信息定位等。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Regions` (
  `region_id` INT NOT NULL AUTO_INCREMENT COMMENT '地区唯一标识ID，主键',
  `name` VARCHAR(100) NOT NULL COMMENT '地区名称 (如: 北京市, 上海市)',
  `sorting_standard_summary` TEXT NULL COMMENT '该地区垃圾分类标准摘要或特殊说明',
  PRIMARY KEY (`region_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE COMMENT '地区名称唯一')
ENGINE = InnoDB
COMMENT = '地区信息表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`Users`
-- 描述: 存储平台用户信息，包括注册用户、管理员、内容编辑等。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Users` (
  `user_id` INT NOT NULL AUTO_INCREMENT COMMENT '用户唯一标识ID，主键',
  `username` VARCHAR(50) NOT NULL COMMENT '登录用户名，唯一',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '加盐哈希后的密码',
  `email` VARCHAR(100) NULL COMMENT '用户邮箱，唯一，可为空',
  `nickname` VARCHAR(50) NULL COMMENT '用户昵称',
  `age_group` ENUM('child', 'teenager', 'adult', 'senior') NULL COMMENT '年龄段，用于内容推荐',
  `region_id` INT NULL COMMENT '用户所属地区ID，外键关联Regions表',
  `role` ENUM('user', 'admin', 'editor') NOT NULL DEFAULT 'user' COMMENT '用户角色 (普通用户, 管理员, 编辑)',
  `registration_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '用户注册日期时间',
  `last_login_date` TIMESTAMP NULL COMMENT '用户最后登录日期时间',
  `is_active` TINYINT(1) NULL DEFAULT 1 COMMENT '账户是否激活 (1:激活, 0:禁用)',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_Users_Regions_idx` (`region_id` ASC) VISIBLE,
  CONSTRAINT `fk_Users_Regions`
    FOREIGN KEY (`region_id`)
    REFERENCES `ZNLJFL`.`Regions` (`region_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '用户信息表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`VideoCategories`
-- 描述: 存储视频内容的主要分类，通常对应垃圾的四大分类或其他环保主题。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`VideoCategories` (
  `category_id` INT NOT NULL AUTO_INCREMENT COMMENT '分类唯一标识ID，主键',
  `name` VARCHAR(100) NOT NULL COMMENT '分类名称 (如: 可回收物, 有害垃圾)',
  `icon_url` VARCHAR(255) NULL COMMENT '分类图标的URL',
  `description` TEXT NULL COMMENT '分类的详细描述',
  PRIMARY KEY (`category_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE COMMENT '分类名称唯一')
ENGINE = InnoDB
COMMENT = '视频/垃圾主分类表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`Videos`
-- 描述: 存储教育视频的元数据信息。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Videos` (
  `video_id` INT NOT NULL AUTO_INCREMENT COMMENT '视频唯一标识ID，主键',
  `title` VARCHAR(255) NOT NULL COMMENT '视频标题',
  `description` TEXT NULL COMMENT '视频内容描述',
  `video_url` VARCHAR(512) NOT NULL COMMENT '视频文件的存储路径或URL',
  `thumbnail_url` VARCHAR(512) NULL COMMENT '视频缩略图的URL',
  `duration_seconds` INT NULL COMMENT '视频时长，单位：秒',
  `uploader_id` INT NULL COMMENT '视频上传者ID，外键关联Users表 (通常是admin或editor)',
  `views_count` INT NULL DEFAULT 0 COMMENT '视频被观看的次数',
  `likes_count` INT NULL DEFAULT 0 COMMENT '视频被点赞的次数',
  `publish_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '视频发布日期时间',
  `status` ENUM('pending', 'published', 'archived') NULL DEFAULT 'pending' COMMENT '视频状态 (待审核, 已发布, 已归档)',
  `suitable_age_groups` SET('child', 'teenager', 'adult', 'senior') NULL COMMENT '视频适宜的年龄段 (可多选)',
  `primary_category_id` INT NULL COMMENT '视频所属的主要分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`video_id`),
  INDEX `fk_Videos_Users_idx` (`uploader_id` ASC) VISIBLE,
  INDEX `fk_Videos_VideoCategories_idx` (`primary_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_Videos_Users`
    FOREIGN KEY (`uploader_id`)
    REFERENCES `ZNLJFL`.`Users` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Videos_VideoCategories`
    FOREIGN KEY (`primary_category_id`)
    REFERENCES `ZNLJFL`.`VideoCategories` (`category_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '教育视频信息表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`KnowledgeArticles`
-- 描述: 存储图文并茂的垃圾分类知识文章。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`KnowledgeArticles` (
  `article_id` INT NOT NULL AUTO_INCREMENT COMMENT '文章唯一标识ID，主键',
  `title` VARCHAR(255) NOT NULL COMMENT '文章标题',
  `content_html` TEXT NOT NULL COMMENT '文章内容，以HTML格式存储，支持图文混排',
  `author_id` INT NULL COMMENT '文章作者ID，外键关联Users表 (通常是admin或editor)',
  `publish_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '文章发布日期时间',
  `views_count` INT NULL DEFAULT 0 COMMENT '文章被阅读的次数',
  `status` ENUM('draft', 'published', 'archived') NULL DEFAULT 'draft' COMMENT '文章状态 (草稿, 已发布, 已归档)',
  `main_category_id` INT NULL COMMENT '文章所属的主要分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`article_id`),
  INDEX `fk_KnowledgeArticles_Users_idx` (`author_id` ASC) VISIBLE,
  INDEX `fk_KnowledgeArticles_VideoCategories_idx` (`main_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_KnowledgeArticles_Users`
    FOREIGN KEY (`author_id`)
    REFERENCES `ZNLJFL`.`Users` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_KnowledgeArticles_VideoCategories`
    FOREIGN KEY (`main_category_id`)
    REFERENCES `ZNLJFL`.`VideoCategories` (`category_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '知识文章表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`Games`
-- 描述: 定义平台提供的不同类型的小游戏。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Games` (
  `game_id` INT NOT NULL AUTO_INCREMENT COMMENT '游戏唯一标识ID，主键',
  `name` VARCHAR(100) NOT NULL COMMENT '游戏名称 (如: 垃圾拖拽分类, 分类知识问答)',
  `description` TEXT NULL COMMENT '游戏玩法描述',
  `game_type` ENUM('drag_and_drop', 'quiz') NOT NULL COMMENT '游戏类型',
  `difficulty_level` ENUM('easy', 'medium', 'hard') NULL DEFAULT 'medium' COMMENT '游戏默认难度级别',
  PRIMARY KEY (`game_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE COMMENT '游戏名称唯一')
ENGINE = InnoDB
COMMENT = '游戏定义表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`QuizQuestions`
-- 描述: 存储问答类游戏的题目、选项及答案。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`QuizQuestions` (
  `question_id` INT NOT NULL AUTO_INCREMENT COMMENT '题目唯一标识ID，主键',
  `game_id` INT NOT NULL COMMENT '所属游戏ID，外键关联Games表 (且game_type=''quiz'')',
  `question_text` TEXT NOT NULL COMMENT '问题描述文本',
  `option_a` VARCHAR(255) NOT NULL COMMENT '选项A内容',
  `option_b` VARCHAR(255) NOT NULL COMMENT '选项B内容',
  `option_c` VARCHAR(255) NOT NULL COMMENT '选项C内容',
  `option_d` VARCHAR(255) NULL COMMENT '选项D内容 (可为空, 适用于3选1或4选1)',
  `correct_option` ENUM('A', 'B', 'C', 'D') NOT NULL COMMENT '正确答案选项',
  `explanation` TEXT NULL COMMENT '答案解析说明',
  `related_category_id` INT NULL COMMENT '题目关联的垃圾分类ID，外键关联VideoCategories表',
  `difficulty` ENUM('easy', 'medium', 'hard') NULL DEFAULT 'medium' COMMENT '题目难度级别',
  PRIMARY KEY (`question_id`),
  INDEX `fk_QuizQuestions_Games_idx` (`game_id` ASC) VISIBLE,
  INDEX `fk_QuizQuestions_VideoCategories_idx` (`related_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_QuizQuestions_Games`
    FOREIGN KEY (`game_id`)
    REFERENCES `ZNLJFL`.`Games` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_QuizQuestions_VideoCategories`
    FOREIGN KEY (`related_category_id`)
    REFERENCES `ZNLJFL`.`VideoCategories` (`category_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '问答游戏题目表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`UserGameScores`
-- 描述: 记录用户玩游戏获得的得分情况。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`UserGameScores` (
  `score_id` INT NOT NULL AUTO_INCREMENT COMMENT '得分记录唯一标识ID，主键',
  `user_id` INT NOT NULL COMMENT '用户ID，外键关联Users表',
  `game_id` INT NOT NULL COMMENT '游戏ID，外键关联Games表',
  `score` INT NOT NULL COMMENT '用户在该局游戏中获得的分数',
  `played_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '游戏进行的日期时间',
  `duration_seconds` INT NULL COMMENT '游戏所用时长，单位：秒 (可为空)',
  PRIMARY KEY (`score_id`),
  INDEX `fk_UserGameScores_Users_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_UserGameScores_Games_idx` (`game_id` ASC) VISIBLE,
  CONSTRAINT `fk_UserGameScores_Users`
    FOREIGN KEY (`user_id`)
    REFERENCES `ZNLJFL`.`Users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_UserGameScores_Games`
    FOREIGN KEY (`game_id`)
    REFERENCES `ZNLJFL`.`Games` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '用户游戏得分记录表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`EnvironmentalReports`
-- 描述: 存储用户通过"随手拍"功能上报的环境问题信息 (如不文明分类、污染举报)。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`EnvironmentalReports` (
  `report_id` INT NOT NULL AUTO_INCREMENT COMMENT '上报记录唯一标识ID，主键',
  `user_id` INT NOT NULL COMMENT '上报用户ID，外键关联Users表',
  `report_type` ENUM('improper_sorting', 'littering', 'pollution_incident', 'other') NOT NULL COMMENT '上报问题类型',
  `description` TEXT NOT NULL COMMENT '问题详细描述',
  `photo_video_urls` TEXT NULL COMMENT '相关照片或视频的URL列表 (可存储为JSON数组字符串或逗号分隔的字符串)',
  `latitude` DECIMAL(10,8) NULL COMMENT '问题发生地点的纬度',
  `longitude` DECIMAL(11,8) NULL COMMENT '问题发生地点的经度',
  `address_text` VARCHAR(255) NULL COMMENT '用户填写的地址或系统解析的地址文本',
  `reported_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上报日期时间',
  `status` ENUM('pending_review', 'verified', 'forwarded', 'resolved', 'invalid') NULL DEFAULT 'pending_review' COMMENT '上报信息处理状态',
  `admin_notes` TEXT NULL COMMENT '管理员审核或处理备注',
  `region_id` INT NULL COMMENT '问题发生地区ID，外键关联Regions表',
  PRIMARY KEY (`report_id`),
  INDEX `fk_EnvironmentalReports_Users_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_EnvironmentalReports_Regions_idx` (`region_id` ASC) VISIBLE,
  CONSTRAINT `fk_EnvironmentalReports_Users`
    FOREIGN KEY (`user_id`)
    REFERENCES `ZNLJFL`.`Users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EnvironmentalReports_Regions`
    FOREIGN KEY (`region_id`)
    REFERENCES `ZNLJFL`.`Regions` (`region_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '环境问题上报表 ("随手拍")';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`RecyclingPoints`
-- 描述: 存储旧物回收点、捐赠渠道等信息，由管理员或认证用户发布。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`RecyclingPoints` (
  `point_id` INT NOT NULL AUTO_INCREMENT COMMENT '回收/捐赠点唯一标识ID，主键',
  `name` VARCHAR(255) NOT NULL COMMENT '回收点/渠道名称',
  `type` ENUM('recycling_station', 'donation_point', 'exchange_info') NOT NULL COMMENT '信息类型 (回收站, 捐赠点, 交换信息)',
  `description` TEXT NULL COMMENT '详细描述信息',
  `address` VARCHAR(255) NOT NULL COMMENT '详细地址',
  `contact_info` VARCHAR(255) NULL COMMENT '联系方式 (电话, 微信等)',
  `acceptable_items` TEXT NULL COMMENT '可接受的物品类型列表 (可存储为JSON数组字符串或逗号分隔的字符串)',
  `region_id` INT NULL COMMENT '所属地区ID，外键关联Regions表',
  `publisher_id` INT NOT NULL COMMENT '信息发布者ID，外键关联Users表 (通常是admin或认证用户)',
  `verified_status` ENUM('pending', 'verified', 'rejected') NULL DEFAULT 'pending' COMMENT '信息审核状态 (待审核, 已验证, 已拒绝)',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP COMMENT '信息创建日期时间',
  `latitude` DECIMAL(10,8) NULL COMMENT '回收点/渠道的纬度 (用于地图展示)',
  `longitude` DECIMAL(11,8) NULL COMMENT '回收点/渠道的经度 (用于地图展示)',
  PRIMARY KEY (`point_id`),
  INDEX `fk_RecyclingPoints_Regions_idx` (`region_id` ASC) VISIBLE,
  INDEX `fk_RecyclingPoints_Users_idx` (`publisher_id` ASC) VISIBLE,
  CONSTRAINT `fk_RecyclingPoints_Regions`
    FOREIGN KEY (`region_id`)
    REFERENCES `ZNLJFL`.`Regions` (`region_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_RecyclingPoints_Users`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `ZNLJFL`.`Users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '旧物回收/捐赠信息平台表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`Video_Category_Mapping`
-- 描述: 视频与视频分类的多对多关联表。一个视频可以属于多个分类。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Video_Category_Mapping` (
  `video_id` INT NOT NULL COMMENT '视频ID，外键关联Videos表',
  `category_id` INT NOT NULL COMMENT '分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`video_id`, `category_id`),
  INDEX `fk_Video_Category_Mapping_VideoCategories_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_Video_Category_Mapping_Videos_idx` (`video_id` ASC) VISIBLE,
  CONSTRAINT `fk_Video_Category_Mapping_Videos`
    FOREIGN KEY (`video_id`)
    REFERENCES `ZNLJFL`.`Videos` (`video_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Video_Category_Mapping_VideoCategories`
    FOREIGN KEY (`category_id`)
    REFERENCES `ZNLJFL`.`VideoCategories` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '视频与分类的关联映射表';


-- -----------------------------------------------------
-- Table `ZNLJFL`.`Article_Category_Mapping`
-- 描述: 知识文章与视频分类的多对多关联表。一篇文章可以关联多个分类主题。
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ZNLJFL`.`Article_Category_Mapping` (
  `article_id` INT NOT NULL COMMENT '文章ID，外键关联KnowledgeArticles表',
  `category_id` INT NOT NULL COMMENT '分类ID，外键关联VideoCategories表',
  PRIMARY KEY (`article_id`, `category_id`),
  INDEX `fk_Article_Category_Mapping_VideoCategories_idx` (`category_id` ASC) VISIBLE,
  INDEX `fk_Article_Category_Mapping_KnowledgeArticles_idx` (`article_id` ASC) VISIBLE,
  CONSTRAINT `fk_Article_Category_Mapping_KnowledgeArticles`
    FOREIGN KEY (`article_id`)
    REFERENCES `ZNLJFL`.`KnowledgeArticles` (`article_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Article_Category_Mapping_VideoCategories`
    FOREIGN KEY (`category_id`)
    REFERENCES `ZNLJFL`.`VideoCategories` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '文章与分类的关联映射表';
