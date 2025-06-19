package com.javaweb.dao;

import com.javaweb.model.User;
import com.javaweb.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // 检查用户名是否存在
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?"; // 假设表名是 Users
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 检查邮箱是否存在
    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 添加用户
    public int addUser(User user) {
        // 在调用此方法前，应已校验用户名和邮箱的唯一
        String sql = "INSERT INTO Users (username, password_hash, email, nickname, age_group, role, registration_date, is_active, current_avatar_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int generatedUserId = 0;

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPasswordHash()); // 密码哈希
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getNickname());
            pstmt.setString(5, user.getAgeGroup());
            pstmt.setString(6, user.getRole() != null ? user.getRole() : "user"); // 默认角色
            pstmt.setTimestamp(7, user.getRegistrationDate() != null ? user.getRegistrationDate() : new Timestamp(System.currentTimeMillis()));
            pstmt.setBoolean(8, user.isActive());
            pstmt.setString(9, user.getCurrentAvatarPath()); // 获取在 User 对象中设置的头像路径

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // --- 获取数据库生成的 user_id ---
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedUserId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return generatedUserId;
    }

    public User getUserByUsername(String username) {
        // --- SQL SELECT 语句中加入 current_avatar_path 字段 ---
        String sql = "SELECT * FROM Users WHERE username = ?";
        User user = null;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setEmail(rs.getString("email"));
                    user.setNickname(rs.getString("nickname"));
                    user.setAgeGroup(rs.getString("age_group"));
                    Integer regionId = (Integer) rs.getObject("region_id");
                    if (regionId != null) {
                        user.setRegionId(regionId);
                    }
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getTimestamp("registration_date"));
                    user.setLastLoginDate(rs.getTimestamp("last_login_date"));
                    user.setActive(rs.getBoolean("is_active"));
                    // --- 新增: 读取并设置 current_avatar_path ---
                    user.setCurrentAvatarPath(rs.getString("current_avatar_path"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // 更新用户最后登录时间
    public boolean updateLastLoginDate(int userId) {
        String sql = "UPDATE Users SET last_login_date = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- 初始化用户的历史头像记录 ---
    public boolean initializeHistoricalAvatars(int userId) {
        String sql = "INSERT INTO user_historical_avatars (user_id, avatar1_path, avatar2_path, avatar3_path) VALUES (?, NULL, NULL, NULL)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId); // 设置新用户的 user_id
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0; // 如果插入成功，返回 true
        } catch (SQLException e) {
            e.printStackTrace(); // 实际项目中应使用日志
            return false;
        }
    }

    public User.HistoricalAvatarPaths getHistoricalAvatars(int userId) {
        String sql = "SELECT avatar1_path, avatar2_path, avatar3_path FROM user_historical_avatars WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new User.HistoricalAvatarPaths(
                            rs.getString("avatar1_path"),
                            rs.getString("avatar2_path"),
                            rs.getString("avatar3_path")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCurrentUserAvatar(int userId, String newAvatarPath) {
        String sql = "UPDATE Users SET current_avatar_path = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newAvatarPath);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateHistoricalAvatars(int userId, String newHist1, String newHist2, String newHist3) {
        String sql = "UPDATE user_historical_avatars SET avatar1_path = ?, avatar2_path = ?, avatar3_path = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newHist1);
            pstmt.setString(2, newHist2);
            pstmt.setString(3, newHist3);
            pstmt.setInt(4, userId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> findAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT user_id, username, email, nickname, role, registration_date, is_active FROM Users ORDER BY registration_date DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setNickname(rs.getString("nickname"));
                user.setRole(rs.getString("role"));
                user.setRegistrationDate(rs.getTimestamp("registration_date"));
                user.setActive(rs.getBoolean("is_active"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    /**
     * 根据用户ID删除一个用户。
     * @param userId 要删除的用户的ID。
     * @return 如果删除成功，返回 true。
     */
    public boolean deleteUserById(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新用户的部分信息（通常由管理员操作）。
     * @param user 包含要更新信息的 User 对象。
     * @return 如果更新成功，返回 true。
     */
    public boolean updateUserByAdmin(User user) {
        String sql = "UPDATE Users SET nickname = ?, email = ?, role = ?, is_active = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getNickname());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getRole());
            pstmt.setBoolean(4, user.isActive());
            pstmt.setInt(5, user.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 【新增】根据用户ID查找用户，用于编辑用户信息前的加载。
     * @param userId 用户ID。
     * @return 返回找到的 User 对象，或 null。
     */
    public User findById(int userId) {
        User user = null;
        String sql = "SELECT user_id, username, email, nickname, role, registration_date, is_active FROM Users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setNickname(rs.getString("nickname"));
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getTimestamp("registration_date"));
                    user.setActive(rs.getBoolean("is_active"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    /**
     * 统计所有注册用户的总数。
     * @return 用户总数。
     */
    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
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