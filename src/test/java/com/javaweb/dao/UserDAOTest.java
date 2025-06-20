package com.javaweb.dao;

import com.javaweb.model.User;
import org.junit.jupiter.api.*; // 引入 JUnit 5 的核心注解

import java.sql.Timestamp; // 【关键修复】引入正确的Timestamp类
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*; // 引入 JUnit 5 的断言工具

/**
 * 这是 UserDAO 的单元测试类。
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class) // 让测试按指定顺序执行
class UserDAOTest {

    private static UserDAO userDAO;
    private static User testUser; // 用于测试的共享用户对象

    @BeforeAll
    static void setUp() {
        userDAO = new UserDAO();
        testUser = new User();
        String uniqueUsername = "test_user_" + UUID.randomUUID().toString().substring(0, 8);
        testUser.setUsername(uniqueUsername);
        testUser.setPasswordHash("test_password_hash");
        testUser.setEmail(uniqueUsername + "@test.com");
        testUser.setNickname("测试昵称");
        testUser.setRole("user");
        testUser.setActive(true);
        // 【关键修复】: 使用 new Timestamp(System.currentTimeMillis()) 来创建一个符合方法要求的对象
        testUser.setRegistrationDate(new Timestamp(System.currentTimeMillis()));
    }

    @AfterAll
    static void tearDown() {
        // 尝试删除测试中创建的用户，保持数据库干净
        User createdUser = userDAO.getUserByUsername(testUser.getUsername());
        if (createdUser != null) {
            userDAO.deleteUserById(createdUser.getUserId());
        }
    }

    /**
     * 测试用例 1: 测试添加一个新用户。
     */
    @Test
    @Order(1)
    @DisplayName("测试添加新用户")
    void addUser_shouldSucceedAndReturnId() {
        // 执行
        int generatedId = userDAO.addUser(testUser);

        // 断言
        assertTrue(generatedId > 0, "成功添加用户后，返回的ID应该大于0");
        testUser.setUserId(generatedId);
    }

    /**
     * 测试用例 2: 测试根据用户名查询用户。
     */
    @Test
    @Order(2)
    @DisplayName("测试根据用户名获取用户")
    void getUserByUsername_shouldReturnCorrectUser() {
        Assumptions.assumeTrue(testUser.getUserId() > 0, "添加用户必须先成功");

        // 执行
        User foundUser = userDAO.getUserByUsername(testUser.getUsername());

        // 断言
        assertNotNull(foundUser, "应该能根据用户名找到用户");
        assertEquals(testUser.getUsername(), foundUser.getUsername(), "找到的用户名应该与我们存入的一致");
    }

    /**
     * 测试用例 3: 测试检查已存在的用户名。
     */
    @Test
    @Order(3)
    @DisplayName("测试检查已存在的用户名")
    void isUsernameExists_forExistingUser_shouldReturnTrue() {
        Assumptions.assumeTrue(testUser.getUserId() > 0, "添加用户必须先成功");

        // 执行
        boolean exists = userDAO.isUsernameExists(testUser.getUsername());

        // 断言
        assertTrue(exists, "对于已存在的用户名，应该返回true");
    }

    /**
     * 测试用例 4: 测试检查不存在的用户名。
     */
    @Test
    @Order(4)
    @DisplayName("测试检查不存在的用户名")
    void isUsernameExists_forNonExistingUser_shouldReturnFalse() {
        // 执行
        boolean exists = userDAO.isUsernameExists("a_very_impossible_username_" + UUID.randomUUID());

        // 断言
        assertFalse(exists, "对于不存在的用户名，应该返回false");
    }

    /**
     * 测试用例 5: 测试由管理员更新用户信息。
     */
    @Test
    @Order(5)
    @DisplayName("测试管理员更新用户信息")
    void updateUserByAdmin_shouldSucceed() {
        Assumptions.assumeTrue(testUser.getUserId() > 0, "添加用户必须先成功");

        // 准备
        User userToUpdate = new User();
        userToUpdate.setUserId(testUser.getUserId());
        String newNickname = "更新后的昵称";
        userToUpdate.setNickname(newNickname);
        userToUpdate.setEmail(testUser.getEmail());
        userToUpdate.setRole("editor");
        userToUpdate.setActive(false);

        // 执行
        boolean success = userDAO.updateUserByAdmin(userToUpdate);

        // 断言
        assertTrue(success, "更新用户信息应该返回true");

        User updatedUser = userDAO.findById(testUser.getUserId());
        assertEquals(newNickname, updatedUser.getNickname(), "昵称应该已被更新");
        assertEquals("editor", updatedUser.getRole(), "角色应该已被更新");
    }

    /**
     * 测试用例 6: 测试查询所有用户列表。
     */
    @Test
    @Order(6)
    @DisplayName("测试查询所有用户")
    void findAllUsers_shouldReturnNonEmptyList() {
        // 执行
        List<User> userList = userDAO.findAllUsers();

        // 断言
        assertNotNull(userList, "用户列表不应为null");
        assertFalse(userList.isEmpty(), "用户列表不应为空");
    }
}
