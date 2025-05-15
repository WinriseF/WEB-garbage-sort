const garbageItemsContainer = document.getElementById('garbage-items');
const bins = document.querySelectorAll('.bin');
const scoreElement = document.getElementById('score');
const resetButton = document.getElementById('reset-button');
const itemCountElement = document.getElementById('item-count'); // 获取显示数量的元素

const currentUserId = document.body.dataset.userId || null;
const currentGameId = 1;

let score = 0;
let draggedItem = null;
const ITEMS_PER_GAME = 20; // 定义每局游戏的垃圾数量
let gameStartTime = null;

function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]]; // ES6 swap
    }
    return array;
}


// --- 游戏初始化与重置 ---
function initializeGame() {
    score = 0;
    updateScore();
    clearGarbageItems();
    populateGarbageItems();
    bins.forEach(bin => {
        bin.classList.remove('correct', 'incorrect', 'drag-over');
        bin.removeEventListener('animationend', removeAnimationClass);
    });
    gameStartTime = new Date();
    const gameEndMessageElement = document.getElementById('game-end-message');
    if (gameEndMessageElement) {
        gameEndMessageElement.style.display = 'none';
    }
}

function clearGarbageItems() {
    garbageItemsContainer.innerHTML = ''; // 清空垃圾项
}

// 从外部列表按难度比例随机选择 
function populateGarbageItems() {
    // 1. 检查外部列表是否存在且有内容
    if (typeof fullGarbageList === 'undefined' || fullGarbageList.length === 0) {
        console.error("垃圾列表 'fullGarbageList' 未定义或为空! 请确保 garbage_data.js 已正确加载。");
        garbageItemsContainer.innerHTML = '<p style="color: red;">错误：无法加载垃圾数据！</p>';
        itemCountElement.textContent = '0';
        return;
    }

    // 2. 按难度分离列表
    const difficultItems = fullGarbageList.filter(item => item.difficult === true);
    const simpleItems = fullGarbageList.filter(item => !item.difficult); // Includes difficult: false or missing

    // 3. 独立打乱两个列表
    shuffleArray(difficultItems);
    shuffleArray(simpleItems);

    // 4. 计算目标数量 (大约 1:2 比例)
    const numDifficultTarget = Math.round(ITEMS_PER_GAME / 3);
    const numSimpleTarget = ITEMS_PER_GAME - numDifficultTarget;

    // 5. 从打乱后的列表中选取所需数量
    // slice 会自动处理数量不足的情况
    const selectedDifficult = difficultItems.slice(0, numDifficultTarget);
    const selectedSimple = simpleItems.slice(0, numSimpleTarget);

    // 6. 合并选出的项目
    let combinedSelectedItems = [...selectedDifficult, ...selectedSimple];

    // 7. 再次打乱合并后的列表，确保显示顺序随机
    shuffleArray(combinedSelectedItems);

    // 8. 更新界面上显示的总项目数
    // (确保显示的是实际选出的数量，以防源列表不足)
    const finalItemCount = combinedSelectedItems.length;
    itemCountElement.textContent = finalItemCount;

    // 9. 生成垃圾项DOM元素
    combinedSelectedItems.forEach((item, index) => {
        const div = document.createElement('div');
        div.textContent = item.name;
        div.id = `item-${index}`; // ID 仍然基于最终列表的索引
        div.classList.add('garbage-item');
        div.dataset.type = item.type; // 存储垃圾类型
        //存储难度信息到 DOM 元素，方便后续可能使用 (例如计分)
        div.dataset.difficult = item.difficult === true;
        div.setAttribute('draggable', 'true');

        // 添加拖拽事件监听
        div.addEventListener('dragstart', dragStart);
        div.addEventListener('dragend', dragEnd);

        garbageItemsContainer.appendChild(div);
    });
}


// --- 拖拽事件处理 (dragStart, dragEnd) ---
function dragStart(event) {
    draggedItem = event.target;
    event.dataTransfer.setData('text/plain', event.target.id);
    // 你也可以在这里传递难度信息，但 dataset 通常更方便
    // event.dataTransfer.setData('difficulty', event.target.dataset.difficult);
    event.dataTransfer.effectAllowed = 'move';
    setTimeout(() => {
        // 检查 event.target 是否仍然有效 (用户可能很快取消拖动)
        if(event.target) {
            event.target.classList.add('dragging');
        }
    }, 0);
    bins.forEach(bin => bin.classList.remove('correct', 'incorrect'));
}

function dragEnd(event) {
    // dragend 即使在拖动失败时也会触发, 确保移除样式
    // 使用 document.getElementById 确保我们操作的是正确的、仍然存在的元素
    const item = document.getElementById(event.dataTransfer.getData('text/plain'));
    if (item) {
         item.classList.remove('dragging');
    }
    // 或者，如果拖动成功，draggedItem 可能已被移除，所以直接用 event.target (如果还存在)
    if (event.target && event.target.classList.contains('garbage-item')) {
         event.target.classList.remove('dragging');
    }

    draggedItem = null; // 清除引用
    bins.forEach(bin => bin.classList.remove('drag-over'));
}


bins.forEach(bin => {
    bin.addEventListener('dragover', dragOver);
    bin.addEventListener('dragleave', dragLeave);
    bin.addEventListener('drop', drop);
});

function dragOver(event) {
    event.preventDefault();
    // 优化: 检查拖拽物是否来自我们的游戏区域 (可选)
    // if (!draggedItem) return;
    if (event.target.classList.contains('bin') && !event.target.classList.contains('drag-over')) {
         bins.forEach(b => b.classList.remove('drag-over'));
         event.target.classList.add('drag-over');
    }
}

function dragLeave(event) {
    // 避免在进入/离开子元素时闪烁
    if (event.target.classList.contains('bin') && !event.target.contains(event.relatedTarget)) {
        event.target.classList.remove('drag-over');
    }
}

// --- drop 函数 (计分逻辑保持不变，但现在可以使用难度信息) ---
function drop(event) {
    event.preventDefault();
    const targetBin = event.target.closest('.bin');
    if (!targetBin || !draggedItem) return;

    targetBin.classList.remove('drag-over');

    const itemType = draggedItem.dataset.type;
    const binType = targetBin.dataset.type;
    // 获取难度信息 (注意 dataset 的值是字符串 'true' 或 'false')
    const isDifficult = draggedItem.dataset.difficult === 'true';

    if (itemType === binType) {
        // 分类正确
        // --- 潜在修改点: 可以根据难度加不同分数 ---
        // score += isDifficult ? 2 : 1; // 例如：困难+2分，简单+1分
        score++; // 当前逻辑：无论难度都+1分
        updateScore();
        showFeedback(targetBin, 'correct');
        draggedItem.remove(); // 移除正确的项
        draggedItem = null; // 清除引用，因为它已被移除
        checkGameCompletion();
    } else {
        // 分类错误
        score--; // 扣分
        if (score < 0) {
            score = 0; // 确保分数不低于 0
        }
        updateScore(); // 更新分数显示
        showFeedback(targetBin, 'incorrect');
        // 错误的项不移除
    }
    // 注意：不要在这里将 draggedItem 设为 null，因为如果分类错误，元素还在
}


// --- 辅助函数 (updateScore, showFeedback, removeAnimationClass, checkGameCompletion) ---
function updateScore() {
    scoreElement.textContent = score;
}

function showFeedback(element, className) {
    element.classList.add(className);
    element.addEventListener('animationend', removeAnimationClass, { once: true });
}

function removeAnimationClass(event) {
     // 检查类名是否存在，避免移除事件监听器时出错
     if(event.target.classList.contains('correct') || event.target.classList.contains('incorrect')){
        event.target.classList.remove('correct', 'incorrect');
     }
}


// --- 游戏结束逻辑修改 ---
function checkGameCompletion() {
    const remainingItems = garbageItemsContainer.querySelectorAll('.garbage-item').length;
    if (remainingItems === 0) {
        const gameEndTime = new Date();
        const durationSeconds = Math.round((gameEndTime - gameStartTime) / 1000);

        let message = `最终得分: ${score}. 用时: ${durationSeconds} 秒. `;
        if (score < ITEMS_PER_GAME * 0.5) {
            message += "还有提升空间哦！";
        } else if (score < ITEMS_PER_GAME * 0.8) {
            message += "表现不错！";
        } else {
            message += "太棒了，垃圾人！";
        }

        // 显示游戏结束消息
        const gameEndMessageElement = document.getElementById('game-end-message'); // 假设HTML中有一个元素显示此消息
        if (gameEndMessageElement) {
            gameEndMessageElement.textContent = message;
            gameEndMessageElement.style.display = 'block';
        } else {
            alert(message); // 后备方案
        }


        // --- 将分数发送到后端 ---
        if (currentUserId && currentGameId) { // 确保用户已登录且游戏ID已知
            console.log(`准备发送分数: userId=${currentUserId}, gameId=${currentGameId}, score=${score}, duration=${durationSeconds}`);
            saveScoreToBackend(currentUserId, currentGameId, score, durationSeconds);
        } else {
            if (!currentUserId) console.warn("用户未登录，分数将不会被保存。");
            if (!currentGameId) console.warn("游戏ID未知，分数将不会被保存。");
        }
    }
}

async function saveScoreToBackend(userId, gameId, finalScore, duration) {
    const data = {
        // userId: userId, // userId 将从后端session获取，避免前端篡改
        gameId: gameId,
        score: finalScore,
        durationSeconds: duration
    };

    try {
        // 注意: URL 需要根据你的 Servlet 映射来调整
        const response = await fetch('../saveGameScore', { // <<--- 假设 Servlet 映射到 /saveGameScore, 且游戏页面在子目录
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data)
        });

        if (response.ok) {
            const result = await response.json(); // 或 response.text() 如果后端只返回文本
            console.log('分数保存成功:', result);
            // 可选：在页面上显示保存成功的消息
            // 例如，在 gameEndMessageElement 旁边添加一个小的提示
        } else {
            console.error('分数保存失败:', response.status, await response.text());
            // 可选：在页面上显示保存失败的消息
        }
    } catch (error) {
        console.error('发送分数时发生网络错误:', error);
        // 可选：在页面上显示网络错误消息
    }
}


// --- 事件监听器 ---
resetButton.addEventListener('click', initializeGame);

// --- 游戏启动 ---
document.addEventListener('DOMContentLoaded', () => {
    if (!document.getElementById('game-end-message')) {
        const messageDiv = document.createElement('div');
        messageDiv.id = 'game-end-message';
        messageDiv.style.display = 'none'; // 默认隐藏
        messageDiv.style.marginTop = '20px';
        messageDiv.style.padding = '10px';
        messageDiv.style.border = '1px solid #ccc';
        messageDiv.style.backgroundColor = '#f9f9f9';
        resetButton.parentNode.insertBefore(messageDiv, resetButton);
    }
    initializeGame();
});