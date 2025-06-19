<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>发布我的闲置</title>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Noto Sans SC', sans-serif; background-color: #f4f7f6; }
    .form-container { max-width: 700px; margin: 30px auto; padding: 40px; background: #fff; border-radius: 12px; box-shadow: 0 5px 25px rgba(0,0,0,0.08); }
    .form-header { text-align: center; margin-bottom: 30px; }
    .form-header h1 { font-size: 26px; font-weight: 700; }
    .form-header p { color: #6c757d; }
    .form-group { margin-bottom: 25px; }
    .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #495057; }
    .form-group input[type="text"], .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 8px; box-sizing: border-box; font-size: 16px; }
    .form-group textarea { resize: vertical; min-height: 120px; }
    .file-upload-wrapper { display: flex; align-items: center; gap: 15px; }
    .custom-file-upload { border: 1px dashed #007bff; color: #007bff; background-color: #f8f9fa; padding: 10px 18px; border-radius: 8px; cursor: pointer; transition: all 0.2s ease; font-weight: 500; }
    .custom-file-upload:hover { background-color: #007bff; color: #fff; border-style: solid; }
    input[type="file"] { display: none; }
    #file-chosen { color: #6c757d; font-style: italic; }
    .privacy-note { font-size: 13px; color: #868e96; margin-top: 8px; }
    button[type="submit"] { width: 100%; padding: 15px; font-size: 18px; font-weight: 700; background-color: #28a745; color: white; border: none; border-radius: 8px; cursor: pointer; }
  </style>
</head>
<body>
<div class="form-container">
  <div class="form-header">
    <h1>发布我的闲置物品</h1>
    <p>让闲置物品流动起来，为环保出一份力！</p>
  </div>

  <form action="${pageContext.request.contextPath}/recycling/post" method="post" enctype="multipart/form-data">
    <div class="form-group">
      <label for="itemName">物品名称 (*)</label>
      <input type="text" id="itemName" name="itemName" required>
    </div>
    <div class="form-group">
      <label for="itemDescription">详细描述 (*)</label>
      <textarea id="itemDescription" name="itemDescription" placeholder="例如：九成新，只用过两次..." required></textarea>
    </div>
    <div class="form-group">
      <label for="photo">上传一张照片</label>
      <div class="file-upload-wrapper">
        <label for="photo" class="custom-file-upload">选择图片</label>
        <input type="file" id="photo" name="photo" accept="image/*">
        <span id="file-chosen">尚未选择文件</span>
      </div>
    </div>
    <div class="form-group">
      <label for="wantedItems">我想要 (*)</label>
      <input type="text" id="wantedItems" name="wantedItems" placeholder="例如：几本书、或写“无偿赠送”" required>
    </div>
    <div class="form-group">
      <label for="contactInfo">我的联系方式 (*)</label>
      <input type="text" id="contactInfo" name="contactInfo" placeholder="微信/QQ/电话" required>
      <p class="privacy-note">注意：此信息将被公开显示，请注意隐私安全。</p>
    </div>
    <button type="submit">确认发布</button>
  </form>
</div>
<script>
  const actualBtn = document.getElementById('photo');
  const fileChosen = document.getElementById('file-chosen');
  actualBtn.addEventListener('change', function(){
    fileChosen.textContent = this.files.length > 0 ? this.files[0].name : '尚未选择文件';
  });
</script>
</body>
</html>
