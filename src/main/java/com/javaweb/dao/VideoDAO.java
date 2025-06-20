/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.dao;

import com.javaweb.model.Video;
import com.javaweb.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VideoDAO {

    /**
     * 查询所有视频，用于后台管理列表。
     * @return 包含所有 Video 对象的列表。
     */
    public List<Video> findAll() {
        List<Video> videoList = new ArrayList<>();
        String sql = "SELECT * FROM Videos ORDER BY publish_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                videoList.add(mapResultSetToVideo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return videoList;
    }

    /**
     * 查询所有状态为 'published' 的视频，用于前台视频列表页。
     */
    public List<Video> findAllPublished() {
        List<Video> videoList = new ArrayList<>();
        String sql = "SELECT * FROM Videos WHERE status = 'published' ORDER BY publish_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                videoList.add(mapResultSetToVideo(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return videoList;
    }

    /**
     * 根据视频ID查询单个视频的详细信息，用于播放页或编辑页。
     */
    public Video findById(int videoId) {
        Video video = null;
        String sql = "SELECT * FROM Videos WHERE video_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, videoId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    video = mapResultSetToVideo(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return video;
    }

    /**
     * 向数据库中插入一条新的视频记录。
     * @param video 包含新视频所有信息的 Video 对象。
     * @return 如果插入成功，返回 true；否则返回 false。
     */
    public boolean addVideo(Video video) {
        String sql = "INSERT INTO Videos (title, description, video_url, thumbnail_url, duration_seconds, " +
                "uploader_id, status, suitable_age_groups, primary_category_id, publish_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, video.getTitle());
            pstmt.setString(2, video.getDescription());
            pstmt.setString(3, video.getVideoUrl());
            pstmt.setString(4, video.getThumbnailUrl());
            pstmt.setObject(5, video.getDurationSeconds());
            pstmt.setObject(6, video.getUploaderId());
            pstmt.setString(7, video.getStatus());
            pstmt.setString(8, video.getSuitableAgeGroups());
            pstmt.setObject(9, video.getPrimaryCategoryId());
            pstmt.setTimestamp(10, new Timestamp(video.getPublishDate().getTime()));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新一条已存在的视频记录。
     * @param video 包含更新后信息的 Video 对象。
     * @return 如果更新成功，返回 true；否则返回 false。
     */
    public boolean updateVideo(Video video) {
        String sql = "UPDATE Videos SET title = ?, description = ?, video_url = ?, thumbnail_url = ?, " +
                "status = ? WHERE video_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, video.getTitle());
            pstmt.setString(2, video.getDescription());
            pstmt.setString(3, video.getVideoUrl());
            pstmt.setString(4, video.getThumbnailUrl());
            pstmt.setString(5, video.getStatus());
            pstmt.setInt(6, video.getVideoId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 根据ID删除一条视频记录。
     * @param videoId 要删除的视频的ID。
     * @return 如果删除成功，返回 true；否则返回 false。
     */
    public boolean deleteVideoById(int videoId) {
        String sql = "DELETE FROM Videos WHERE video_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, videoId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 统计所有已发布的视频总数。
     * @return 已发布的视频总数。
     */
    public int countTotalPublishedVideos() {
        String sql = "SELECT COUNT(*) FROM Videos WHERE status = 'published'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 辅助方法，将ResultSet的一行数据映射到一个Video对象，避免代码重复
    private Video mapResultSetToVideo(ResultSet rs) throws SQLException {
        Video video = new Video();
        video.setVideoId(rs.getInt("video_id"));
        video.setTitle(rs.getString("title"));
        video.setDescription(rs.getString("description"));
        video.setVideoUrl(rs.getString("video_url"));
        video.setThumbnailUrl(rs.getString("thumbnail_url"));
        video.setDurationSeconds((Integer) rs.getObject("duration_seconds"));
        video.setUploaderId((Integer) rs.getObject("uploader_id"));
        video.setViewsCount(rs.getInt("views_count"));
        video.setLikesCount(rs.getInt("likes_count"));
        video.setPublishDate(rs.getTimestamp("publish_date"));
        video.setStatus(rs.getString("status"));
        video.setSuitableAgeGroups(rs.getString("suitable_age_groups"));
        video.setPrimaryCategoryId((Integer) rs.getObject("primary_category_id"));
        return video;
    }
}
