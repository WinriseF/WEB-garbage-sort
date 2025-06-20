/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;

import com.javaweb.dao.UserGameScoreDAO;
import com.javaweb.model.UserGameScoreEntry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/leaderboard")
public class LeaderboardServlet extends HttpServlet {
    private UserGameScoreDAO userGameScoreDAO;

    @Override
    public void init() throws ServletException {
        userGameScoreDAO = new UserGameScoreDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String gameIdParam = request.getParameter("gameId");
        int gameId = 1; // 默认拖拽游戏
        if (gameIdParam != null && !gameIdParam.isEmpty()) {
            try {
                gameId = Integer.parseInt(gameIdParam);
            } catch (NumberFormatException e) {
                System.err.println("无效的 gameId 参数: " + gameIdParam);
            }
        }

        int limit = 10; // 显示前10名
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
                if (limit <= 0 || limit > 100) limit = 10;
            } catch (NumberFormatException e) {
                System.err.println("无效的 limit 参数: " + limitParam);
            }
        }


        List<UserGameScoreEntry> leaderboardData = userGameScoreDAO.getLeaderboard(gameId, limit);

        request.setAttribute("leaderboardData", leaderboardData);
        request.setAttribute("gameIdForTitle", gameId);

        request.getRequestDispatcher("/games/leaderboard.jsp").forward(request, response);
    }
}