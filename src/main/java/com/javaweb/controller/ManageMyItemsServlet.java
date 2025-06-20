/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

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
import java.util.List;

/**
 * 这个Servlet负责处理对用户“我的发布”页面的请求。
 * 它会验证用户登录状态，并查询该用户发布的所有物品。
 */
@WebServlet("/recycling/my-items") // 将此Servlet映射到 /recycling/my-items URL
public class ManageMyItemsServlet extends HttpServlet {

    private RecyclingDAO recyclingDAO;

    @Override
    public void init() {
        // 在Servlet初始化时，创建一个DAO实例，以便后续使用
        recyclingDAO = new RecyclingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. 安全检查：必须确保用户已登录才能查看“我的发布”
        HttpSession session = request.getSession(false); // false表示不创建新session
        if (session == null || session.getAttribute("loggedInUser") == null) {
            // 如果未登录，重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        // 2. 获取当前登录的用户信息
        User user = (User) session.getAttribute("loggedInUser");

        // 3. 调用DAO中我们刚刚添加的 findItemsByUserId 方法，获取该用户的物品列表
        List<RecyclingItem> myItemsList = recyclingDAO.findItemsByUserId(user.getUserId());

        // 4. 将获取到的列表存入request对象中，准备交给JSP页面
        request.setAttribute("myItemsList", myItemsList);

        // 5. 将请求转发到JSP页面进行显示
        request.getRequestDispatcher("/recycling/my_items.jsp").forward(request, response);
    }
}
