package com.javaweb.controller;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

@WebServlet("/captchaImage")
public class CaptchaServlet extends HttpServlet {
    private static final int WIDTH = 150; // 图片宽度
    private static final int HEIGHT = 50;  // 图片高度
    private static final int FONT_SIZE = 28; // 字体大小
    private static final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //生成随机数和运算符
        int num1 = random.nextInt(10) + 1; // 1-10
        int num2 = random.nextInt(10) + 1; // 1-10
        char operatorChar;
        String operatorStr;
        int answer;

        int opChoice = random.nextInt(3); // 0 for +, 1 for -, 2 for *

        switch (opChoice) {
            case 0: // 加法
                operatorChar = '+';
                operatorStr = "+";
                answer = num1 + num2;
                break;
            case 1: // 减法
                operatorChar = '-';
                operatorStr = "-";
                if (num1 < num2) {
                    int temp = num1;
                    num1 = num2;
                    num2 = temp;
                }
                answer = num1 - num2;
                break;
            default:
                operatorChar = '×'; // 使用更美观的乘号
                operatorStr = "×";
                num1 = random.nextInt(9) + 1; // 1-9
                num2 = random.nextInt(9) + 1; // 1-9
                answer = num1 * num2;
                break;
        }

        String question = String.format("%d %s %d = ?", num1, operatorStr, num2);

        // 2. 将答案存储在 Session 中
        HttpSession session = request.getSession();
        session.setAttribute("captchaAnswer", String.valueOf(answer)); // 将答案转为字符串存储

        // 3. 创建图像缓冲
        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();

        // ---- 开始绘制 ----

        // 设置背景颜色
        g2d.setColor(Color.WHITE);
        g2d.fillRect(0, 0, WIDTH, HEIGHT);

        // 抗锯齿
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        // 绘制更复杂的干扰线
        for (int i = 0; i < 8; i++) { // 增加干扰线数量
            // 随机颜色，偏深色系
            g2d.setColor(new Color(random.nextInt(150), random.nextInt(150), random.nextInt(150)));
            // 随机粗细
            g2d.setStroke(new BasicStroke(random.nextFloat() * 1.5f + 0.5f)); // 0.5 to 2.0
            int x1 = random.nextInt(WIDTH);
            int y1 = random.nextInt(HEIGHT);
            int x2 = random.nextInt(WIDTH);
            int y2 = random.nextInt(HEIGHT);
            g2d.drawLine(x1, y1, x2, y2);
        }

        // 设置字体 (在获取 FontMetrics 之前设置)
        Font font;
        try {
            font = new Font("Arial", Font.BOLD, FONT_SIZE);
        } catch (Exception e) {
            font = new Font(Font.SANS_SERIF, Font.BOLD, FONT_SIZE);
        }
        g2d.setFont(font);
        FontMetrics fm = g2d.getFontMetrics();

        // 绘制问题文本 (逐字符绘制，以应用旋转和位移)
        int charSpacing = 2; // 字符间的额外间距
        int totalTextWidth = 0;
        for (char c : question.toCharArray()) {
            totalTextWidth += fm.charWidth(c) + charSpacing;
        }
        totalTextWidth -= charSpacing; // 最后一个字符后面没有间距

        int currentX = (WIDTH - totalTextWidth) / 2;
        // 调整基线y，为上下浮动和旋转留出空间
        int baseLineY = (HEIGHT - fm.getAscent() - fm.getDescent()) / 2 + fm.getAscent() + 5;


        for (char c : question.toCharArray()) {
            if (Character.isWhitespace(c)) { // 处理空格
                currentX += fm.charWidth(c) + charSpacing;
                continue;
            }

            // 保存当前变换状态
            AffineTransform originalTransform = g2d.getTransform();

            // 轻微随机旋转 (-15 to +15 度)
            double angle = (random.nextDouble() - 0.5) * Math.toRadians(30); // angle in radians
            g2d.translate(currentX, baseLineY); // 将原点移到字符绘制位置的左下角附近
            g2d.rotate(angle);

            // 轻微随机上下浮动 (-2 to +2 像素)
            int yOffset = random.nextInt(5) - 2;

            // 字符颜色轻微随机 (非常接近黑色)
            int R = random.nextInt(30);
            int G = random.nextInt(30);
            int B = random.nextInt(30);
            g2d.setColor(new Color(R, G, B));

            g2d.drawString(String.valueOf(c), 0, yOffset); // 在新的原点(旋转后)绘制字符

            // 恢复原始变换状态
            g2d.setTransform(originalTransform);

            currentX += fm.charWidth(c) + charSpacing;
        }


        // 绘制更多的噪点
        for (int i = 0; i < 200; i++) { // 大幅增加噪点数量
            int x_dot = random.nextInt(WIDTH);
            int y_dot = random.nextInt(HEIGHT);
            // 噪点颜色更随机，但避免纯白
            g2d.setColor(new Color(random.nextInt(225), random.nextInt(225), random.nextInt(225)));
            g2d.fillRect(x_dot, y_dot, 1, 1);
        }

        g2d.dispose();
        // ---- 绘制结束 ----

        // 4. 设置响应头，告诉浏览器这是一个图片
        response.setContentType("image/png");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
        response.setDateHeader("Expires", 0); // Proxies.

        // 5. 将图片写入响应输出流
        OutputStream os = response.getOutputStream();
        try {
            ImageIO.write(image, "png", os);
        } finally {
            if (os != null) {
                os.close(); // 确保输出流被关闭
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 一般验证码请求是GET，但也可以处理POST以防万一
        doGet(request, response);
    }
}