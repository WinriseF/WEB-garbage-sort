package com.javaweb.model;

/**
 * A DTO (Data Transfer Object) that combines an EnvironmentalReport with the submitter's nickname.
 */
public class ReportWithUser extends EnvironmentalReport {

    private String userNickname;

    public String getUserNickname() {
        // If the nickname is null or empty (anonymous), return a default a friendly name.
        if (userNickname == null || userNickname.trim().isEmpty()) {
            return "一位热心市民";
        }
        return userNickname;
    }

    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname;
    }
}
