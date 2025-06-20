/**
 * @author Winrisef
 * @see <a href="https://github.com/WinriseF">https://github.com/WinriseF</a>
 * date 2025/6/20
 * description:
 */

package com.javaweb.controller;
//验证码执行文件逻辑
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

        int opChoice = random.nextInt(3);

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
                operatorChar = '*';
                operatorStr = "*";
                num1 = random.nextInt(9) + 1;
                num2 = random.nextInt(9) + 1;
                answer = num1 * num2;
                break;
        }

        String question = String.format("%d %s %d = ?", num1, operatorStr, num2);

        // 将答案存储在 Session 中
        HttpSession session = request.getSession();
        session.setAttribute("captchaAnswer", String.valueOf(answer)); // 将答案转为字符串存储

        // 创建图像缓冲
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
        for (int i = 0; i < 32; i++) { // 增加干扰线数量
            // 随机颜色，偏深色系
            g2d.setColor(new Color(random.nextInt(150), random.nextInt(150), random.nextInt(150)));
            // 随机粗细
            g2d.setStroke(new BasicStroke(random.nextFloat() * 1.5f + 1.5f)); // 0.5 to 2.0
            int x1 = random.nextInt(WIDTH);
            int y1 = random.nextInt(HEIGHT);
            int x2 = random.nextInt(WIDTH);
            int y2 = random.nextInt(HEIGHT);
            g2d.drawLine(x1, y1, x2, y2);
        }

        // 设置字体
        Font font;
        try {
            font = new Font("Arial", Font.BOLD, FONT_SIZE);
        } catch (Exception e) {
            font = new Font(Font.SANS_SERIF, Font.BOLD, FONT_SIZE);
        }
        g2d.setFont(font);
        FontMetrics fm = g2d.getFontMetrics();

        // 绘制问题文本
        int charSpacing = 2; // 字符间的额外间距
        int totalTextWidth = 0;
        for (char c : question.toCharArray()) {
            totalTextWidth += fm.charWidth(c) + charSpacing;
        }
        totalTextWidth -= charSpacing;

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

            // 轻微随机旋转
            double angle = (random.nextDouble() - 0.5) * Math.toRadians(45); // angle in radians
            g2d.translate(currentX, baseLineY); // 将原点移到字符绘制位置的左下角附近
            g2d.rotate(angle);

            // 轻微随机上下浮动
            int yOffset = random.nextInt(10) - 2;

            // 字符颜色轻微随机
            int R = random.nextInt(30);
            int G = random.nextInt(30);
            int B = random.nextInt(30);
            g2d.setColor(new Color(R, G, B));

            g2d.drawString(String.valueOf(c), 0, yOffset);

            // 恢复原始变换状态
            g2d.setTransform(originalTransform);

            currentX += fm.charWidth(c) + charSpacing;
        }


        g2d.dispose();
        // ---- 绘制结束 ----

        //设置响应头
        response.setContentType("image/png");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        //将图片写入响应输出流
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
        doGet(request, response);
    }
}