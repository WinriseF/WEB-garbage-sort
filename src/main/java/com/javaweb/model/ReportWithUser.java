/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.model;


public class ReportWithUser extends EnvironmentalReport {

    private String userNickname;

    public String getUserNickname() {
        if (userNickname == null || userNickname.trim().isEmpty()) {
            return "一位热心市民";
        }
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }
}
