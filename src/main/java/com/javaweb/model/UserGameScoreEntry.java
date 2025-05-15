package com.javaweb.model; // 或你的包名

import java.sql.Timestamp;

public class UserGameScoreEntry {
    private String nickname;
    private int score;
    private Integer durationSeconds; // 可以为 null
    private Timestamp playedAt;

    public UserGameScoreEntry(String nickname, int score, Integer durationSeconds, Timestamp playedAt) {
        this.nickname = nickname;
        this.score = score;
        this.durationSeconds = durationSeconds;
        this.playedAt = playedAt;
    }

    // Getters
    public String getNickname() { return nickname; }
    public int getScore() { return score; }
    public Integer getDurationSeconds() { return durationSeconds; }
    public Timestamp getPlayedAt() { return playedAt; }
}