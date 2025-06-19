package com.javaweb.model;

import java.util.List;

/**
 * 这是一个数据传输对象 (DTO)，用于封装物品详情页需要的所有信息。
 * 它包含了主物品的详情、发布者的昵称，以及该发布者的其他闲置物品列表。
 */
public class ItemDetail {

    private RecyclingItem mainItem;
    private String userNickname;
    private List<RecyclingItem> otherItemsBySameUser;

    // --- Getters and Setters ---

    public RecyclingItem getMainItem() {
        return mainItem;
    }

    public void setMainItem(RecyclingItem mainItem) {
        this.mainItem = mainItem;
    }

    public String getUserNickname() {
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }

    public List<RecyclingItem> getOtherItemsBySameUser() {
        return otherItemsBySameUser;
    }

    public void setOtherItemsBySameUser(List<RecyclingItem> otherItemsBySameUser) {
        this.otherItemsBySameUser = otherItemsBySameUser;
    }
}
