package com.javaweb.controller; // 或你的包名

import com.javaweb.dao.UserGameScoreDAO;
import com.javaweb.model.UserGameScoreEntry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/leaderboard") // 例如 ${pageContext.request.contextPath}/leaderboard
public class LeaderboardServlet extends HttpServlet {
    private UserGameScoreDAO userGameScoreDAO;

    @Override
    public void init() throws ServletException {
        userGameScoreDAO = new UserGameScoreDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 从请求参数获取 game_id，如果未提供，则默认为拖拽游戏 (ID 1)
        String gameIdParam = request.getParameter("gameId");
        int gameId = 1; // 默认拖拽游戏
        if (gameIdParam != null && !gameIdParam.isEmpty()) {
            try {
                gameId = Integer.parseInt(gameIdParam);
            } catch (NumberFormatException e) {
                // gameId 无效，保持默认或显示错误
                System.err.println("无效的 gameId 参数: " + gameIdParam);
            }
        }

        int limit = 10; // 显示前10名
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
                if (limit <= 0 || limit > 100) limit = 10; // 限制范围
            } catch (NumberFormatException e) {
                System.err.println("无效的 limit 参数: " + limitParam);
            }
        }


        List<UserGameScoreEntry> leaderboardData = userGameScoreDAO.getLeaderboard(gameId, limit);

        request.setAttribute("leaderboardData", leaderboardData);
        request.setAttribute("gameIdForTitle", gameId); // 用于在标题中显示是哪个游戏的排行榜

        request.getRequestDispatcher("/jsp/leaderboard.jsp").forward(request, response);
        // 将 JSP 放在 WEB-INF 下，防止直接通过 URL 访问
    }
}