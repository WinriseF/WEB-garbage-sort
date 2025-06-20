/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;

import com.javaweb.dao.RecyclingDAO;
import com.javaweb.model.ItemDetail;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/recycling/detail")
public class ItemDetailServlet extends HttpServlet {
    private RecyclingDAO recyclingDAO;

    @Override
    public void init() {
        recyclingDAO = new RecyclingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("id"));
            ItemDetail itemDetail = recyclingDAO.findItemDetailById(itemId);

            if (itemDetail != null) {
                request.setAttribute("itemDetail", itemDetail);
                request.getRequestDispatcher("/recycling/item_detail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "请求的物品未找到。");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的物品ID。");
        }
    }
}

