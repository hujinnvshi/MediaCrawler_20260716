# Mac系统测试指南 - 招聘信息采集系统

## 🍎 Mac系统快速开始 (3步)

### 第一步：克隆项目

打开**终端**（Terminal.app），执行：

```bash
# 1. 进入工作目录（可选）
cd ~/Desktop

# 2. 克隆项目
git clone git@github.com:hujinnvshi/MediaCrawler_20260716.git

# 3. 进入项目目录
cd MediaCrawler_20260716
```

---

### 第二步：安装依赖

```bash
# 1. 检查Python版本（需要Python 3.10+）
python3 --version

# 2. 创建虚拟环境
python3 -m venv venv

# 3. 激活虚拟环境
source venv/bin/activate

# 4. 安装Python依赖
pip install -r requirements.txt

# 5. 安装浏览器驱动（需要一点时间）
playwright install chrome
```

**预期输出**：
```
✓ Python 3.12.3 (或其他版本)
✓ 虚拟环境创建成功
✓ 依赖安装完成
✓ Chrome浏览器安装完成
```

---

### 第三步：配置并运行

```bash
# 重要！Mac上使用二维码登录（更方便）
# 修改配置文件

nano config/base_config.py
```

**找到并修改以下配置：**

```python
# 修改平台
PLATFORM = "zhihu"

# 修改登录方式为二维码
LOGIN_TYPE = "qrcode"  # 👈 改为 qrcode

# Cookie留空即可（扫码登录不需要）
COOKIES = ""

# Mac上有图形界面，关闭无头模式
HEADLESS = False  # 👈 改为 False（会打开浏览器窗口）

# 爬取数量（可选，保持50或改为20测试）
CRAWLER_MAX_NOTES_COUNT = 20  # 👈 建议先用20条快速测试
```

**保存并退出**（nano按 `Ctrl+X`，然后 `Y`，然后 `Enter`）

---

### 第四步：运行爬虫

```bash
# 确保在虚拟环境中
source venv/bin/activate

# 运行爬虫（会打开Chrome浏览器窗口）
python main.py --platform zhihu --lt qrcode --type search
```

---

## 🎯 运行过程说明

### 1. 浏览器会自动打开

```
┌──────────────────────────────────┐
│     Chrome浏览器窗口              │
│                                  │
│  https://www.zhihu.com           │
│                                  │
│  ┌────────────┐                  │
│  │            │                  │
│  │  二维码    │  ← 用知乎APP扫码  │
│  │            │                  │
│  └────────────┘                  │
│                                  │
│  请使用知乎APP扫描二维码登录      │
└──────────────────────────────────┘
```

### 2. 拿出手机，打开知乎APP

```
步骤：
1. 打开知乎APP
2. 点击 "+" → "扫一扫"
3. 扫描屏幕上的二维码
4. 在手机上确认登录
```

### 3. 登录成功后，自动开始爬取

```
✓ 登录成功！
│
├─ 正在采集: 字节跳动 内推 (20条)...
├─ 正在采集: 腾讯招聘 (20条)...
├─ 正在采集: 阿里内推 (20条)...
└─ ...（共7个关键词）
```

### 4. 等待完成（约5-8分钟）

```
进度提示：
██████████████████░░░░░  60%

预计剩余时间: 3分钟
已采集: 84条
```

### 5. 查看结果

```bash
# 查看采集的数据
ls -lh output/zhihu/search/

# 查看数据内容（前5条）
cat output/zhihu/search/zhihu_search_*.json | head -100
```

---

## 📊 运行数据分析

```bash
# 确保在虚拟环境中
source venv/bin/activate

# 运行分析工具
python analyze_data.py
```

**预期输出**：
```
╔══════════════════════════════════════════════╗
║       招聘信息数据分析工具 v1.0              ║
╚══════════════════════════════════════════════╝

📂 正在加载数据...
✓ 已加载 140 条帖子
✓ 已加载 280 条评论

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 数据质量分析
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 质量分布:
  ⭐ 高质量: 25 条
  ⭐ 中等质量: 45 条
  ⭐ 低质量: 70 条

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔥 热门招聘帖 Top 10
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. 字节跳动2024春招启动
   👍 156 点赞  |  💬 23 评论  |  👤 字节跳动招聘
   🔗 https://www.zhihu.com/question/xxxxx

...

✓ 分析完成！
```

---

## ⚠️ 常见问题

### Q1: 提示 "command not found: python3"

**解决方案**：
```bash
# Mac上可能需要使用 python
python --version

# 或者安装Python 3
brew install python@3.11
```

### Q2: 提示 "playwright: command not found"

**解决方案**：
```bash
# 重新安装浏览器驱动
source venv/bin/activate
playwright install chrome
```

### Q3: 浏览器打不开或闪退

**解决方案**：
```bash
# 检查HEADLESS配置
grep "HEADLESS" config/base_config.py

# 应该是 HEADLESS = False（Mac图形界面）
# 如果是 True，改为 False
```

### Q4: 二维码扫描后没反应

**解决方案**：
- 确保手机和Mac在同一网络
- 等待10-20秒
- 刷新浏览器页面重试

### Q5: 速度太慢怎么办

**解决方案**：
```bash
# 减少爬取数量
nano config/base_config.py
# 改为 CRAWLER_MAX_NOTES_COUNT = 10
```

---

## 🎬 完整操作流程（首次）

```bash
# 1. 打开终端
# 按 Command + Space，输入 "Terminal"，回车

# 2. 进入项目目录
cd ~/Desktop/MediaCrawler_20260716

# 3. 激活虚拟环境
source venv/bin/activate

# 4. 运行爬虫
python main.py --platform zhihu --lt qrcode --type search

# 5. 等待浏览器打开
# (会自动打开Chrome窗口)

# 6. 用知乎APP扫码
# (拿出手机操作)

# 7. 等待采集完成
# (约5-8分钟)

# 8. 分析数据
python analyze_data.py

# 9. 查看结果
open output/zhihu/search/  # 在Finder中打开
```

---

## 📱 图形界面优势

Mac系统上的优势：

```
✅ 浏览器可视化
   └─ 可以看到采集过程
   └─ 方便调试问题

✅ 二维码登录
   └─ 无需手动配置Cookie
   └─ 登录态保持时间长

✅ Finder集成
   └─ 双击查看JSON文件
   └─ 拖拽到Excel分析
```

---

## 🔧 推荐工具

### Mac上的JSON查看器

**选项1: 使用VSCode**
```bash
# 安装VSCode
brew install --cask visual-studio-code

# 打开JSON文件
code output/zhihu/search/zhihu_search_*.json
```

**选项2: 使用Xcode**
```bash
# 直接在Xcode中查看JSON
open output/zhihu/search/zhihu_search_*.json
```

**选项3: 使用在线工具**
- 复制JSON内容
- 访问: https://jsoneditoronline.org/
- 粘贴查看

---

## 📈 下一步

测试成功后：

1. **调整关键词**
   ```bash
   nano config/base_config.py
   # 修改 KEYWORDS
   ```

2. **增加采集数量**
   ```bash
   nano config/base_config.py
   # 修改 CRAWLER_MAX_NOTES_COUNT = 50
   ```

3. **定时运行**
   ```bash
   # 使用launchd设置定时任务
   # 或使用crontab
   ```

4. **数据分析**
   ```bash
   python analyze_data.py
   ```

---

## 🎓 学习资源

- [QUICKSTART.md](QUICKSTART.md) - 快速参考
- [WORKFLOW.md](WORKFLOW.md) - 完整流程
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - 使用指南

---

**准备好了吗？在Mac上打开终端，开始吧！** 🚀

**预计时间**：
- 首次安装: 10-15分钟
- 运行测试: 5-8分钟
- 总计: 20分钟内完成首次采集

**遇到问题？** 参考上面的常见问题部分，或者查看详细文档。
