package com.javaweb.model;

import java.sql.Timestamp;
import java.util.Date;

public class User {
    private int userId;
    private String username;
    private String passwordHash; // 存储哈希后的密码
    private String email;
    private String nickname;
    private String ageGroup; // 对应数据库 ENUM('child', 'teenager', 'adult', 'senior')
    private Integer regionId; // 可以为 null
    private String role;     // 对应数据库 ENUM('user', 'admin', 'editor')
    private Timestamp registrationDate;
    private Timestamp lastLoginDate;
    private boolean isActive; // 对应数据库 TINYINT(1)

    // 构造函数 (可以有多个，例如一个无参，一个包含所有必要字段)
    public User() {
    }

    public User(String username, String passwordHash, String email, String nickname, String ageGroup, String role) {
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.nickname = nickname;
        this.ageGroup = ageGroup;
        this.role = role;
        this.isActive = true; // 默认激活
        this.registrationDate = new Timestamp(new Date().getTime()); // 设置当前时间为注册时间
    }


    // Getter 和 Setter 方法 (为所有字段生成)
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAgeGroup() {
        return ageGroup;
    }

    public void setAgeGroup(String ageGroup) {
        this.ageGroup = ageGroup;
    }

    public Integer getRegionId() {
        return regionId;
    }

    public void setRegionId(Integer regionId) {
        this.regionId = regionId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Timestamp registrationDate) {
        this.registrationDate = registrationDate;
    }

    public Timestamp getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Timestamp lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    // (可选) toString() 方法，方便调试
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", nickname='" + nickname + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}