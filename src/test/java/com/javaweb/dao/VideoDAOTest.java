package com.javaweb.dao;

import com.javaweb.model.User;
import com.javaweb.model.Video;
import org.junit.jupiter.api.*;
import java.util.Date;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class VideoDAOTest {

    private static VideoDAO videoDAO;
    private static UserDAO userDAO;
    private static User testUploader; // 用于测试的上传者
    private static Video testVideo; // 用于测试的视频

    @BeforeAll
    static void setUp() {
        videoDAO = new VideoDAO();
        userDAO = new UserDAO();

        // 1. 创建一个临时的用户作为上传者
        User uploader = new User();
        uploader.setUsername("video_test_uploader");
        uploader.setPasswordHash("password");
        uploader.setRole("editor");
        uploader.setActive(true);
        int uploaderId = userDAO.addUser(uploader);
        uploader.setUserId(uploaderId);
        testUploader = uploader;

        // 2. 准备一个测试视频对象
        testVideo = new Video();
        testVideo.setTitle("测试视频标题");
        testVideo.setDescription("这是一个测试视频的描述。");
        testVideo.setVideoUrl("//player.bilibili.com/player.html?bvid=BV13M4m1y72d");
        testVideo.setThumbnailUrl("https://placehold.co/400x225");
        testVideo.setUploaderId(testUploader.getUserId());
        testVideo.setStatus("published");
        testVideo.setPublishDate(new Date());
    }

    @AfterAll
    static void tearDown() {
        // 清理测试数据
        if (testVideo != null && testVideo.getVideoId() > 0) {
            videoDAO.deleteVideoById(testVideo.getVideoId());
        }
        if (testUploader != null && testUploader.getUserId() > 0) {
            userDAO.deleteUserById(testUploader.getUserId());
        }
    }

    @Test
    @Order(1)
    @DisplayName("测试添加新视频")
    void addVideo_shouldSucceed() {
        boolean success = videoDAO.addVideo(testVideo);
        assertTrue(success, "添加视频应该成功");

        // 为了能进行后续测试，我们需要找到刚添加的视频并获取其ID
        // 这是一个简化的做法，更严谨的做法是让addVideo返回ID
        List<Video> videos = videoDAO.findAllPublished();
        assertFalse(videos.isEmpty(), "视频列表不应为空");
        Video addedVideo = videos.get(0); // 假设最新添加的在最前面
        testVideo.setVideoId(addedVideo.getVideoId());
        assertTrue(testVideo.getVideoId() > 0, "应该能获取到新添加视频的ID");
    }

    @Test
    @Order(2)
    @DisplayName("测试根据ID查找视频")
    void findById_shouldReturnCorrectVideo() {
        Assumptions.assumeTrue(testVideo.getVideoId() > 0, "添加视频必须先成功");

        Video foundVideo = videoDAO.findById(testVideo.getVideoId());
        assertNotNull(foundVideo, "应该能根据ID找到视频");
        assertEquals(testVideo.getTitle(), foundVideo.getTitle(), "找到的视频标题应该一致");
    }

    @Test
    @Order(3)
    @DisplayName("测试删除视频")
    void deleteVideoById_shouldSucceed() {
        Assumptions.assumeTrue(testVideo.getVideoId() > 0, "添加视频必须先成功");

        boolean success = videoDAO.deleteVideoById(testVideo.getVideoId());
        assertTrue(success, "删除视频应该成功");

        Video videoAfterDeletion = videoDAO.findById(testVideo.getVideoId());
        assertNull(videoAfterDeletion, "视频删除后应该无法再被找到");
    }
}
