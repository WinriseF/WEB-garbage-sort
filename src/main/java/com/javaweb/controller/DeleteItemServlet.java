package com.javaweb.controller;

import com.javaweb.dao.RecyclingDAO;
import com.javaweb.model.RecyclingItem;
import com.javaweb.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/recycling/delete")
public class DeleteItemServlet extends HttpServlet {
    private RecyclingDAO recyclingDAO;

    @Override
    public void init() {
        recyclingDAO = new RecyclingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "请先登录再执行操作。");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");

        try {
            int itemId = Integer.parseInt(request.getParameter("id"));

            // 【关键安全检查】: 验证当前用户是否是该物品的所有者
            RecyclingItem itemToDelete = recyclingDAO.findItemById(itemId);
            if (itemToDelete != null && itemToDelete.getUserId() == user.getUserId()) {
                // 验证通过，执行删除
                recyclingDAO.deleteItemById(itemId);
                // 删除成功后，重定向回“我的发布”页面
                response.sendRedirect(request.getContextPath() + "/recycling/my-items");
            } else {
                // 如果物品不存在，或用户试图删除不属于自己的物品，则拒绝操作
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权删除此物品。");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的物品ID。");
        }
    }
}
