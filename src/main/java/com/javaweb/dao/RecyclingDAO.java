/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.dao;

import com.javaweb.model.ItemDetail;
import com.javaweb.model.RecyclingItem;
import com.javaweb.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * “旧物利用”功能的数据访问对象 (DAO)。
 * 负责所有与 RecyclingItems 表相关的数据库操作。
 */
public class RecyclingDAO {

    /**
     * 向数据库中添加一个新的闲置物品。
     * 关键：新发布的物品状态会默认设置为 "available"。
     * @param item 包含新物品信息的 RecyclingItem 对象。
     * @return 如果添加成功，返回 true；否则返回 false。
     */
    public boolean addItem(RecyclingItem item) {
        String sql = "INSERT INTO RecyclingItems (user_id, item_name, item_description, photo_urls, wanted_items, contact_info, status, posted_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, item.getUserId());
            pstmt.setString(2, item.getItemName());
            pstmt.setString(3, item.getItemDescription());
            pstmt.setString(4, item.getPhotoUrls());
            pstmt.setString(5, item.getWantedItems());
            pstmt.setString(6, item.getContactInfo());
            pstmt.setString(7, "available"); // 【关键点】确保新发布的状态是 'available'
            pstmt.setTimestamp(8, new Timestamp(item.getPostedAt().getTime()));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 查询所有状态为“可交换”的物品，用于“跳蚤市场”列表页。
     * 关键：这个方法是“市场”能看见物品的保证，它只查找 status = 'available' 的物品。
     * @return 包含所有可用物品的列表。
     */
    public List<RecyclingItem> findAllAvailableItems() {
        List<RecyclingItem> items = new ArrayList<>();
        String sql = "SELECT * FROM RecyclingItems WHERE status = 'available' ORDER BY posted_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * 根据用户ID查询其发布的所有物品，用于“我的发布”页面。
     * 关键：这个方法是“我的发布”功能的核心，请确保它存在。
     * @param userId 要查询的用户ID。
     * @return 该用户发布的所有物品列表。
     */
    public List<RecyclingItem> findItemsByUserId(int userId) {
        List<RecyclingItem> items = new ArrayList<>();
        String sql = "SELECT * FROM RecyclingItems WHERE user_id = ? ORDER BY posted_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * 根据ID获取单个物品详情，主要用于删除前的安全验证。
     * @param itemId 物品ID。
     * @return 返回找到的 RecyclingItem 对象，或 null。
     */
    public RecyclingItem findItemById(int itemId) {
        RecyclingItem item = null;
        String sql = "SELECT * FROM RecyclingItems WHERE item_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    item = mapResultSetToItem(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return item;
    }

    /**
     * 获取物品详情页所需的全部复合数据。
     * @param itemId 要查询的主物品ID。
     * @return 返回一个 ItemDetail 对象，如果未找到主物品，则返回 null。
     */
    public ItemDetail findItemDetailById(int itemId) {
        ItemDetail itemDetail = new ItemDetail();
        RecyclingItem mainItem;
        String userNickname;
        int userId;

        String mainItemSql = "SELECT r.*, u.nickname FROM RecyclingItems r " +
                "JOIN Users u ON r.user_id = u.user_id " +
                "WHERE r.item_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(mainItemSql)) {
            pstmt.setInt(1, itemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    mainItem = mapResultSetToItem(rs);
                    userNickname = rs.getString("nickname");
                    userId = mainItem.getUserId();
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }

        itemDetail.setMainItem(mainItem);
        itemDetail.setUserNickname(userNickname);

        List<RecyclingItem> otherItems = new ArrayList<>();
        String otherItemsSql = "SELECT * FROM RecyclingItems WHERE user_id = ? AND item_id != ? AND status = 'available' ORDER BY posted_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(otherItemsSql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, itemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    otherItems.add(mapResultSetToItem(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        itemDetail.setOtherItemsBySameUser(otherItems);
        return itemDetail;
    }

    /**
     * 根据ID删除一个物品。
     * @param itemId 要删除的物品ID。
     * @return 如果删除成功，返回 true。
     */
    public boolean deleteItemById(int itemId) {
        String sql = "DELETE FROM RecyclingItems WHERE item_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 辅助方法，将ResultSet的一行数据映射到一个RecyclingItem对象，避免代码重复。
     */
    private RecyclingItem mapResultSetToItem(ResultSet rs) throws SQLException {
        RecyclingItem item = new RecyclingItem();
        item.setItemId(rs.getInt("item_id"));
        item.setUserId(rs.getInt("user_id"));
        item.setItemName(rs.getString("item_name"));
        item.setItemDescription(rs.getString("item_description"));
        item.setPhotoUrls(rs.getString("photo_urls"));
        item.setWantedItems(rs.getString("wanted_items"));
        item.setContactInfo(rs.getString("contact_info"));
        item.setStatus(rs.getString("status"));
        item.setPostedAt(rs.getTimestamp("posted_at"));
        return item;
    }
}
