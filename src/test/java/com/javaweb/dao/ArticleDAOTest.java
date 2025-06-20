package com.javaweb.dao;

import com.javaweb.model.Article;
import com.javaweb.model.User;
import org.junit.jupiter.api.*;
import java.util.Date;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ArticleDAOTest {

    private static ArticleDAO articleDAO;
    private static UserDAO userDAO;
    private static User testAuthor;
    private static Article testArticle;

    @BeforeAll
    static void setUp() {
        articleDAO = new ArticleDAO();
        userDAO = new UserDAO();

        User author = new User();
        author.setUsername("article_test_author");
        author.setPasswordHash("password");
        author.setRole("admin");
        author.setActive(true);
        int authorId = userDAO.addUser(author);
        author.setUserId(authorId);
        testAuthor = author;

        testArticle = new Article();
        testArticle.setTitle("测试文章标题");
        testArticle.setContentHtml("<p>这是一段测试内容。</p>");
        testArticle.setAuthorId(testAuthor.getUserId());
        testArticle.setStatus("published");
        testArticle.setPublishDate(new Date());
    }

    @AfterAll
    static void tearDown() {
        if (testArticle != null && testArticle.getArticleId() > 0) {
            articleDAO.deleteArticleById(testArticle.getArticleId());
        }
        if (testAuthor != null && testAuthor.getUserId() > 0) {
            userDAO.deleteUserById(testAuthor.getUserId());
        }
    }

    @Test
    @Order(1)
    @DisplayName("测试添加新文章")
    void addArticle_shouldSucceed() {
        boolean success = articleDAO.addArticle(testArticle);
        assertTrue(success, "添加文章应该成功");
    }
}
