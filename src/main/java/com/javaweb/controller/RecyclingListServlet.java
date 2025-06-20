package com.javaweb.controller;

import com.javaweb.dao.RecyclingDAO;
import com.javaweb.model.RecyclingItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 这个Servlet负责处理对“旧物利用市场”主列表页的请求。
 */
@WebServlet("/recycling")
public class RecyclingListServlet extends HttpServlet {

    private RecyclingDAO recyclingDAO;

    @Override
    public void init() {
        // 在Servlet初始化时，创建一个DAO实例
        recyclingDAO = new RecyclingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. 调用DAO的 findAllAvailableItems() 方法。
        //    这个方法会执行SQL查询 "SELECT * FROM RecyclingItems WHERE status = 'available' ..."
        //    确保了我们只获取那些可以被展示的物品。
        List<RecyclingItem> itemList = recyclingDAO.findAllAvailableItems();

        // 2. 将获取到的物品列表（即使是空的）作为一个属性，存入到request对象中。
        request.setAttribute("itemList", itemList);

        // 3. 将请求（连同我们刚刚存入的数据）转发给JSP页面。
        request.getRequestDispatcher("/recycling/recycling_list.jsp").forward(request, response);
    }
}
