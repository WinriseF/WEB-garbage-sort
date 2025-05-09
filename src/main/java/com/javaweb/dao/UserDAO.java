package com.javaweb.dao;

import com.javaweb.model.User;
import com.javaweb.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt; // 引入 JBCrypt

import java.sql.*;

public class UserDAO {

    // 检查用户名是否存在
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 实际项目中应使用日志
        }
        return false;
    }

    // 检查邮箱是否存在
    public boolean isEmailExists(String email) {
        // 注意：数据库中 email 字段允许为 NULL，但如果它有 UNIQUE 约束，查询时需要考虑
        // 如果 email 不是 NOT NULL 且 UNIQUE，此方法可能需要调整
        if (email == null || email.trim().isEmpty()) {
            return false; // 如果允许邮箱为空，则空邮箱不视为“存在”
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

    // 添加用户 (注册)
    public boolean addUser(User user) {
        // 在调用此方法前，应已校验用户名和邮箱的唯一性
        String sql = "INSERT INTO Users (username, password_hash, email, nickname, age_group, role, registration_date, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPasswordHash()); // 密码应已哈希
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getNickname());
            pstmt.setString(5, user.getAgeGroup());
            pstmt.setString(6, user.getRole() != null ? user.getRole() : "user"); // 默认角色
            pstmt.setTimestamp(7, user.getRegistrationDate() != null ? user.getRegistrationDate() : new Timestamp(System.currentTimeMillis()));
            pstmt.setBoolean(8, user.isActive());
            // region_id 可以是 null，所以不在此处设置，除非 user 对象中有值

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 根据用户名获取用户 (登录时使用)
    public User getUserByUsername(String username) {
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
                    // 注意：rs.getInt() 对于数据库中 NULL 的整型会返回 0，如果想区分 NULL，应该使用 rs.getObject("region_id") 然后判断是否为 null
                    Integer regionId = (Integer) rs.getObject("region_id");
                    if (regionId != null) {
                        user.setRegionId(regionId);
                    }
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getTimestamp("registration_date"));
                    user.setLastLoginDate(rs.getTimestamp("last_login_date"));
                    user.setActive(rs.getBoolean("is_active"));
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
}