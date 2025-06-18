package com.javaweb.dao; // 或你的包名

import com.javaweb.model.UserGameScoreEntry; // 需要创建一个简单的POJO来封装排行榜条目
import com.javaweb.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserGameScoreDAO {

    public boolean addScore(int userId, int gameId, int score, Integer durationSeconds) {
        String sql = "INSERT INTO UserGameScores (user_id, game_id, score, played_at, duration_seconds) VALUES (?, ?, ?, CURRENT_TIMESTAMP, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, gameId);
            pstmt.setInt(3, score);
            if (durationSeconds != null) {
                pstmt.setInt(4, durationSeconds);
            } else {
                pstmt.setNull(4, Types.INTEGER);
            }

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // 使用日志框架
            return false;
        }
    }

    // 获取排行榜数据 (按分数降序，然后按游戏用时升序，最后按游戏时间降序作为次要排序)
    // gameId 用于指定哪个游戏的排行榜
    public List<UserGameScoreEntry> getLeaderboard(int gameId, int limit) {
        List<UserGameScoreEntry> leaderboard = new ArrayList<>();
        // 查询用户昵称、分数、游戏时长、游戏时间
        // "巅峰排名" 通常指历史最高分，所以我们可能需要每个用户的最高分
        // 这里先做一个简单的排名，取最近的最高分记录
        // 如果要严格的“每个用户的历史最高分”排名，SQL会更复杂
        String sql = "SELECT u.nickname, ugs.score, ugs.duration_seconds, ugs.played_at " +
                "FROM UserGameScores ugs " +
                "JOIN Users u ON ugs.user_id = u.user_id " +
                "WHERE ugs.game_id = ? " +
                "ORDER BY ugs.score DESC, ugs.duration_seconds ASC, ugs.played_at DESC " +
                "LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, gameId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String nickname = rs.getString("nickname");
                int score = rs.getInt("score");
                Integer duration = (Integer) rs.getObject("duration_seconds"); // getObject for nullable int
                Timestamp playedAt = rs.getTimestamp("played_at");
                leaderboard.add(new UserGameScoreEntry(nickname, score, duration, playedAt));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 使用日志框架
        }
        return leaderboard;
    }

    /**
     * 统计所有游戏记录的总数。
     * @return 游戏总次数。
     */
    public int countTotalGamePlays() {
        String sql = "SELECT COUNT(*) FROM UserGameScores";
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
}