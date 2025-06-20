/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.model;

import java.util.List;


public class ItemDetail {

    private RecyclingItem mainItem;
    private String userNickname;
    private List<RecyclingItem> otherItemsBySameUser;

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
