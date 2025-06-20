package com.javaweb.dao;

import com.javaweb.model.RecyclingItem;
import com.javaweb.model.User;
import org.junit.jupiter.api.*;
import java.util.Date;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RecyclingDAOTest {

    private static RecyclingDAO recyclingDAO;
    private static UserDAO userDAO;
    private static User testItemOwner;
    private static RecyclingItem testItem;

    @BeforeAll
    static void setUp() {
        recyclingDAO = new RecyclingDAO();
        userDAO = new UserDAO();

        User owner = new User();
        owner.setUsername("item_test_owner");
        owner.setPasswordHash("password");
        owner.setRole("user");
        owner.setActive(true);
        int ownerId = userDAO.addUser(owner);
        owner.setUserId(ownerId);
        testItemOwner = owner;

        testItem = new RecyclingItem();
        testItem.setUserId(testItemOwner.getUserId());
        testItem.setItemName("测试闲置物品");
        testItem.setItemDescription("一个用于单元测试的闲置物品。");
        testItem.setWantedItems("测试想要的物品");
        testItem.setContactInfo("测试联系方式");
        testItem.setPostedAt(new Date());
    }

    @AfterAll
    static void tearDown() {
        if (testItem != null && testItem.getItemId() > 0) {
            recyclingDAO.deleteItemById(testItem.getItemId());
        }
        if (testItemOwner != null && testItemOwner.getUserId() > 0) {
            userDAO.deleteUserById(testItemOwner.getUserId());
        }
    }

    @Test
    @Order(1)
    @DisplayName("测试发布新闲置物品")
    void addItem_shouldSucceed() {
        boolean success = recyclingDAO.addItem(testItem);
        assertTrue(success, "发布新物品应该成功");

        // 获取ID用于后续测试
        List<RecyclingItem> items = recyclingDAO.findItemsByUserId(testItemOwner.getUserId());
        assertFalse(items.isEmpty());
        testItem.setItemId(items.get(0).getItemId());
    }

    @Test
    @Order(2)
    @DisplayName("测试查询所有可交换物品")
    void findAllAvailableItems_shouldContainTestItem() {
        Assumptions.assumeTrue(testItem.getItemId() > 0, "发布物品必须先成功");

        List<RecyclingItem> availableItems = recyclingDAO.findAllAvailableItems();
        boolean found = availableItems.stream().anyMatch(item -> item.getItemId() == testItem.getItemId());
        assertTrue(found, "市场列表应该包含我们刚刚发布的测试物品");
    }
}
