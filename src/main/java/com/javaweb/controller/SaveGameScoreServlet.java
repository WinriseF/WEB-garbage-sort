/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;

import com.google.gson.Gson;
import com.javaweb.dao.UserGameScoreDAO;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/saveGameScore")
public class SaveGameScoreServlet extends HttpServlet {
    private UserGameScoreDAO userGameScoreDAO;
    private Gson gson; // 用于解析JSON

    @Override
    public void init() throws ServletException {
        userGameScoreDAO = new UserGameScoreDAO();
        gson = new Gson(); // 需在 pom.xml 中添加 Gson 依赖
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        Map<String, Object> respMap = new HashMap<>();

        if (loggedInUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 未授权
            respMap.put("status", "error");
            respMap.put("message", "用户未登录，无法保存分数。");
            response.getWriter().write(gson.toJson(respMap));
            return;
        }

        try {
            // 读取请求体中的 JSON 数据
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String requestBody = sb.toString();

            // 解析 JSON 数据到 GameScoreData 对象 (或直接用 Map)
            GameScoreData scoreData = gson.fromJson(requestBody, GameScoreData.class);

            if (scoreData == null || scoreData.getGameId() == null || scoreData.getScore() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 错误请求
                respMap.put("status", "error");
                respMap.put("message", "无效的游戏数据。");
                response.getWriter().write(gson.toJson(respMap));
                return;
            }

            // 使用会话中的 userId，而不是前端传递的（更安全）
            int userId = loggedInUser.getUserId();
            int gameId = scoreData.getGameId();
            int scoreValue = scoreData.getScore();
            Integer durationSeconds = scoreData.getDurationSeconds(); // 可能为 null

            // 调用 DAO 保存数据
            boolean success = userGameScoreDAO.addScore(userId, gameId, scoreValue, durationSeconds);

            if (success) {
                respMap.put("status", "success");
                respMap.put("message", "分数已成功保存！");
                response.getWriter().write(gson.toJson(respMap));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                respMap.put("status", "error");
                respMap.put("message", "保存分数时发生服务器错误。");
                response.getWriter().write(gson.toJson(respMap));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            respMap.put("status", "error");
            respMap.put("message", "处理请求时发生异常: " + e.getMessage());
            response.getWriter().write(gson.toJson(respMap));
        }
    }

    private static class GameScoreData {
        private Integer gameId;
        private Integer score;
        private Integer durationSeconds;

        public Integer getGameId() { return gameId; }
        public Integer getScore() { return score; }
        public Integer getDurationSeconds() { return durationSeconds; }
    }
}