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
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;
import java.util.UUID;

@WebServlet("/recycling/post")
@MultipartConfig
public class PostItemServlet extends HttpServlet {

    private RecyclingDAO recyclingDAO;
    private static final String UPLOAD_DIR_NAME = "uploads" + File.separator + "recycling";

    @Override
    public void init() {
        recyclingDAO = new RecyclingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        request.getRequestDispatcher("/recycling/post_item_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "请先登录再发布物品");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");

        String itemName = request.getParameter("itemName");
        String itemDescription = request.getParameter("itemDescription");
        String wantedItems = request.getParameter("wantedItems");
        String contactInfo = request.getParameter("contactInfo");

        Part filePart = request.getPart("photo");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String relativePathToSave = null;

        if (fileName != null && !fileName.isEmpty()) {
            String applicationPath = getServletContext().getRealPath("");
            String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR_NAME;
            File uploadDir = new File(uploadFilePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            filePart.write(uploadFilePath + File.separator + uniqueFileName);
            relativePathToSave = (UPLOAD_DIR_NAME + File.separator + uniqueFileName).replace(File.separator, "/");
        }

        RecyclingItem item = new RecyclingItem();
        item.setUserId(user.getUserId());
        item.setItemName(itemName);
        item.setItemDescription(itemDescription);
        item.setWantedItems(wantedItems);
        item.setContactInfo(contactInfo);
        item.setPhotoUrls(relativePathToSave);
        item.setPostedAt(new Date());

        boolean success = recyclingDAO.addItem(item);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/recycling");
        } else {
            request.setAttribute("errorMessage", "发布失败，请稍后重试。");
            request.getRequestDispatcher("/recycling/post_item_form.jsp").forward(request, response);
        }
    }
}
