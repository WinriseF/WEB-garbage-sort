package com.javaweb.model;

import java.util.Date;

/**
 * Video 模型类，对应数据库中的 'Videos' 表。
 */
public class Video {

    private int videoId;
    private String title;
    private String description;
    private String videoUrl;
    private String thumbnailUrl;
    private Integer durationSeconds;
    private Integer uploaderId;
    private int viewsCount;
    private int likesCount;
    private Date publishDate;
    private String status;
    private String suitableAgeGroups;
    private Integer primaryCategoryId;

    public Video() {}


    public int getVideoId() { return videoId; }
    public void setVideoId(int videoId) { this.videoId = videoId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getVideoUrl() { return videoUrl; }
    public void setVideoUrl(String videoUrl) { this.videoUrl = videoUrl; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
    public Integer getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(Integer durationSeconds) { this.durationSeconds = durationSeconds; }
    public Integer getUploaderId() { return uploaderId; }
    public void setUploaderId(Integer uploaderId) { this.uploaderId = uploaderId; }
    public int getViewsCount() { return viewsCount; }
    public void setViewsCount(int viewsCount) { this.viewsCount = viewsCount; }
    public int getLikesCount() { return likesCount; }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }
    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSuitableAgeGroups() { return suitableAgeGroups; }
    public void setSuitableAgeGroups(String suitableAgeGroups) { this.suitableAgeGroups = suitableAgeGroups; }
    public Integer getPrimaryCategoryId() { return primaryCategoryId; }
    public void setPrimaryCategoryId(Integer primaryCategoryId) { this.primaryCategoryId = primaryCategoryId; }
}