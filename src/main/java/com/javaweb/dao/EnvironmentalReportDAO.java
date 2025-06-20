/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.dao;

import com.javaweb.model.EnvironmentalReport;
import com.javaweb.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 负责与 'EnvironmentalReports' 表进行所有数据库交互的DAO。
 * 这是该功能的最终、完整版本。
 */
public class EnvironmentalReportDAO {

    /**
     * 添加一条新的上报记录。
     * @param report 包含上报信息的对象。
     * @return 如果成功，返回 true。
     */
    public boolean addReport(EnvironmentalReport report) {
        String sql = "INSERT INTO EnvironmentalReports (user_id, report_type, description, photo_video_urls, address_text, reported_at, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (report.getUserId() == 0) { // 0 表示未登录用户
                pstmt.setNull(1, Types.INTEGER);
            } else {
                pstmt.setInt(1, report.getUserId());
            }
            pstmt.setString(2, report.getReportType());
            pstmt.setString(3, report.getDescription());
            pstmt.setString(4, report.getPhotoUrls());
            pstmt.setString(5, report.getAddressText());
            pstmt.setTimestamp(6, new Timestamp(report.getReportedAt().getTime()));
            pstmt.setString(7, report.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 查询所有上报记录（无论状态）。
     * @return 包含所有上报记录的列表。
     */
    public List<EnvironmentalReport> findAllReports() {
        List<EnvironmentalReport> reports = new ArrayList<>();
        // 后台管理需要看到所有信息
        String sql = "SELECT * FROM EnvironmentalReports ORDER BY reported_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * 【为问题广场新增】查询所有公开的上报记录。
     * @return 返回已核实或已解决的上报列表。
     */
    public List<EnvironmentalReport> findAllPublicReports() {
        List<EnvironmentalReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM EnvironmentalReports WHERE status IN ('verified', 'resolved') ORDER BY reported_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                reports.add(mapResultSetToReport(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * 根据用户ID查询其所有提交历史。
     * @param userId 要查询的用户ID。
     * @return 该用户的所有上报列表。
     */
    public List<EnvironmentalReport> findReportsByUserId(int userId) {
        List<EnvironmentalReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM EnvironmentalReports WHERE user_id = ? ORDER BY reported_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reports.add(mapResultSetToReport(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * 根据ID查询单个上报的完整信息。
     */
    public EnvironmentalReport findReportById(int reportId) {
        EnvironmentalReport report = null;
        String sql = "SELECT * FROM EnvironmentalReports WHERE report_id = ?";
        try(Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reportId);
            try(ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) {
                    report = mapResultSetToReport(rs);
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return report;
    }

    /**
     * 更新上报的状态和管理员备注。
     */
    public boolean updateReportStatus(int reportId, String newStatus, String adminNotes) {
        String sql = "UPDATE EnvironmentalReports SET status = ?, admin_notes = ? WHERE report_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, adminNotes);
            pstmt.setInt(3, reportId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 辅助方法，将ResultSet的一行数据映射到一个EnvironmentalReport对象
    private EnvironmentalReport mapResultSetToReport(ResultSet rs) throws SQLException {
        EnvironmentalReport report = new EnvironmentalReport();
        report.setReportId(rs.getInt("report_id"));
        report.setUserId(rs.getInt("user_id"));
        report.setReportType(rs.getString("report_type"));
        report.setDescription(rs.getString("description"));
        report.setPhotoUrls(rs.getString("photo_video_urls"));
        report.setAddressText(rs.getString("address_text"));
        report.setReportedAt(rs.getTimestamp("reported_at"));
        report.setStatus(rs.getString("status"));
        report.setAdminNotes(rs.getString("admin_notes"));
        return report;
    }
}
