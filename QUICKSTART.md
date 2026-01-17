# 招聘信息采集 - 快速参考指南

## 🎯 一句话说明

**自动化采集知乎等平台的招聘信息，结构化存储，便于筛选和分析**

---

## 📊 业务流程速览

```
配置关键词 → 运行爬虫 → 采集数据 → 筛选分析 → 获取招聘信息
   (1分钟)    (15分钟)   (自动)    (手动)     (目标)
```

---

## ⚡ 快速开始 (3步)

### 1️⃣ 配置关键词
```bash
vim config/base_config.py
# 修改这一行：
KEYWORDS = "你的关键词1,你的关键词2"
```

### 2️⃣ 配置Cookie
```bash
# 参考文档获取知乎Cookie
cat COOKIE_GUIDE.md

# 编辑配置文件
vim config/base_config.py
# 修改：
COOKIES = "你复制的Cookie"
```

### 3️⃣ 运行爬虫
```bash
./run_crawler.sh
# 或
source venv/bin/activate
python main.py --platform zhihu --lt cookie --type search
```

---

## 📁 数据存储位置

```
output/zhihu/
├── search/
│   └── zhihu_search_20260117.json    # 帖子数据
└── comments/
    └── zhihu_comments_20260117.json   # 评论数据
```

---

## 🔧 关键配置说明

| 配置项 | 当前值 | 说明 |
|--------|--------|------|
| PLATFORM | zhihu | 目标平台 |
| KEYWORDS | 字节跳动内推,... | 搜索关键词 |
| CRAWLER_MAX_NOTES_COUNT | 50 | 爬取数量 |
| SAVE_DATA_OPTION | json | 存储格式 |
| HEADLESS | True | 无头模式 |
| LOGIN_TYPE | cookie | 登录方式 |

---

## 📋 数据结构

### 帖子数据
```json
{
  "title": "招聘标题",
  "content_text": "招聘内容",
  "voteup_count": 点赞数,
  "user_nickname": "发布者",
  "content_url": "链接地址"
}
```

### 评论数据
```json
{
  "content": "评论内容",
  "user_nickname": "评论者",
  "like_count": 点赞数
}
```

---

## 🎯 筛选策略

```python
# 1. 高质量标准
if 点赞数 >= 10 and 评论数 >= 5:
    return "高质量"

# 2. 关键词匹配
招聘关键词 = ["招聘", "内推", "校招", "实习"]
公司关键词 = ["字节跳动", "腾讯", "阿里", "美团"]

# 3. 时效性
if 发布时间 <= 30天:
    return "近期有效"
```

---

## 🔍 常见使用场景

### 场景1: 采集特定公司招聘信息
```python
KEYWORDS = "字节跳动内推,字节跳动招聘,字节跳动校招"
```

### 场景2: 采集特定职位信息
```python
KEYWORDS = "Java工程师招聘,前端开发招聘,算法工程师"
```

### 场景3: 采集校招信息
```python
KEYWORDS = "2024校招,春季校招,实习生招聘,校园招聘"
```

---

## ⚠️ 注意事项

1. **Cookie有效期**: 7-30天，失效后需重新获取
2. **爬取频率**: 建议每天1-2次，避免频繁请求
3. **数据质量**: 需要二次筛选，去除无关信息
4. **合规使用**: 仅用于个人学习，禁止商业用途

---

## 📚 相关文档

| 文档 | 说明 |
|------|------|
| `WORKFLOW.md` | 完整业务流程文档 |
| `workflow_diagram.txt` | 流程图详解 |
| `COOKIE_GUIDE.md` | Cookie获取指南 |
| `README.md` | 项目说明文档 |
| `config/base_config.py` | 配置文件 |

---

## 🆘 快速故障排除

| 问题 | 解决方案 |
|------|----------|
| 提示未登录 | 重新获取Cookie |
| 找不到数据 | 检查output目录 |
| 浏览器打不开 | 设置HEADLESS=True |
| 爬取速度慢 | 减少CRAWLER_MAX_NOTES_COUNT |

---

## 📞 获取帮助

```bash
# 查看完整文档
cat WORKFLOW.md

# 查看流程图
cat workflow_diagram.txt

# 查看Cookie指南
cat COOKIE_GUIDE.md

# 运行环境检测
./run_crawler.sh
```

---

**更新时间**: 2026-01-17
**版本**: v1.0
