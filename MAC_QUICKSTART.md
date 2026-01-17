# 🍎 Mac系统快速测试 - 一页纸指南

## 🚀 3步开始（5分钟准备，8分钟运行）

### 第1步：克隆项目 (1分钟)

打开**终端**（Terminal.app），复制粘贴：

```bash
cd ~/Desktop && git clone git@github.com:hujinnvshi/MediaCrawler_20260716.git && cd MediaCrawler_20260716
```

---

### 第2步：安装依赖 (5-10分钟)

```bash
# 检查环境
./check_mac_env.sh

# 安装依赖
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
playwright install chrome
```

---

### 第3步：运行测试 (8分钟)

```bash
# 激活环境（如果还没激活）
source venv/bin/activate

# 运行爬虫（会打开Chrome浏览器窗口）
python main.py --platform zhihu --lt qrcode --type search

# 拿出手机，用知乎APP扫描屏幕上的二维码
# 等待自动采集完成（约8分钟）
```

---

## 📱 扫码登录流程

```
1. Chrome浏览器自动打开
   ↓
2. 显示知乎登录二维码
   ↓
3. 手机打开知乎APP → 点击"+" → "扫一扫"
   ↓
4. 扫描屏幕二维码 → 在手机确认登录
   ↓
5. 浏览器自动登录成功 → 开始采集
   ↓
6. 等待8分钟 → 采集完成
```

---

## 📊 查看结果

```bash
# 分析数据
python analyze_data.py

# 在Finder中打开结果文件夹
open output/zhihu/search/
```

---

## ⚙️ 配置说明

项目已配置为Mac友好模式：

- ✅ 平台：知乎
- ✅ 登录：二维码（图形界面）
- ✅ 浏览器：会打开窗口
- ✅ 关键词：7个招聘关键词
- ✅ 数量：20条/关键词（共140条）

**如需修改配置**：
```bash
nano config/base_config.py
```

---

## 🆘 遇到问题？

### Python版本过低
```bash
brew install python@3.11
```

### 浏览器驱动问题
```bash
source venv/bin/activate
playwright install chrome
```

### 二维码扫描没反应
- 等待10-20秒
- 刷新浏览器重试

---

## 📚 更多文档

```bash
# 查看完整Mac指南
cat MAC_GUIDE.md

# 查看快速开始
cat QUICKSTART.md

# 查看使用指南
cat USAGE_GUIDE.md
```

---

**准备好了吗？在Mac上打开终端，粘贴上面的命令开始吧！** 🎉

---

**预计时间**：20分钟内完成首次采集
**数据产出**：140条招聘信息
