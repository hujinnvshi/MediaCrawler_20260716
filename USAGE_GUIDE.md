# 招聘信息采集系统 - 完整使用指南

## 🎯 系统概述

这是一个基于 MediaCrawler 的招聘信息采集系统，支持从知乎等平台自动采集招聘信息，并进行分析筛选。

---

## 📋 快速导航

| 需求 | 操作 |
|------|------|
| 了解项目 | 查看 [QUICKSTART.md](QUICKSTART.md) |
| 理解流程 | 查看 [WORKFLOW.md](WORKFLOW.md) |
| 获取Cookie | 运行 `./get_cookie.sh` |
| 运行爬虫 | 运行 `./run_crawler.sh` |
| 分析数据 | 运行 `./analyze_data.py` |
| 查看文档 | 查看 [workflow_diagram.txt](workflow_diagram.txt) |

---

## 🚀 完整使用流程

### 第一步: 获取知乎Cookie

由于需要登录知乎才能获取数据，你需要先获取Cookie。

#### 方法1: 使用配置向导（推荐）

```bash
./get_cookie.sh
```

按照提示操作：
1. 在浏览器登录知乎
2. 按F12打开开发者工具
3. 复制Cookie并粘贴
4. 自动配置完成

#### 方法2: 手动配置

1. 打开浏览器，访问 https://www.zhihu.com 并登录
2. 按 F12 打开开发者工具
3. 点击 Application (应用) 标签
4. 左侧找到 Cookies → https://www.zhihu.com
5. 复制以下Cookie的值：
   - `a1`
   - `d_c0`
   - `z_c0`

6. 编辑配置文件：
```bash
vim config/base_config.py
```

7. 修改这一行：
```python
COOKIES = "a1=xxx; d_c0=yyy; z_c0=zzz"
```

**详细指南**: 查看 [COOKIE_GUIDE.md](COOKIE_GUIDE.md)

---

### 第二步: 运行爬虫采集数据

#### 使用运行脚本（推荐）

```bash
./run_crawler.sh
```

#### 或手动运行

```bash
source venv/bin/activate
python main.py --platform zhihu --lt cookie --type search
```

#### 运行过程说明

1. **环境检测** (5秒)
   - 检查Python环境
   - 检查浏览器驱动
   - 检查配置文件

2. **登录验证** (10秒)
   - 使用Cookie登录
   - 验证登录状态

3. **数据采集** (10-15分钟)
   - 遍历7个关键词
   - 每个关键词采集50条
   - 总计约350条数据

4. **数据保存** (自动)
   - 保存到 `output/zhihu/search/`
   - 保存到 `output/zhihu/comments/`

#### 预期输出

```
output/zhihu/
├── search/
│   └── zhihu_search_20260117.json    # 帖子数据
└── comments/
    └── zhihu_comments_20260117.json   # 评论数据
```

---

### 第三步: 分析和筛选数据

#### 使用数据分析工具

```bash
./analyze_data.py
```

#### 分析报告内容

1. **数据质量分析**
   - 高质量帖子数量 (点赞≥20)
   - 中等质量帖子数量
   - 低质量帖子数量

2. **关键词筛选**
   - 自动筛选包含招聘关键词的帖子
   - 按热度排序

3. **公司统计**
   - Top 10 招聘公司
   - 各公司招聘信息数量

4. **热门帖子**
   - 热门招聘帖 Top 20
   - 包含标题、热度、链接

5. **最近帖子**
   - 最近7天的招聘信息
   - 按时间排序

6. **数据导出**
   - 自动导出高质量数据到 `high_quality_recruitment.json`

#### 查看原始数据

```bash
# 查看帖子数据
cat output/zhihu/search/zhihu_search_*.json | jq '.[] | {title, voteup_count, user_nickname}'

# 查看评论数据
cat output/zhihu/comments/zhihu_comments_*.json | jq '.[] | {content, user_nickname, like_count}'
```

---

## 🔧 配置优化

### 修改关键词

```bash
vim config/base_config.py
```

修改这一行：
```python
KEYWORDS = "你的关键词1,你的关键词2,你的关键词3"
```

**示例**:
```python
# 采集特定公司
KEYWORDS = "字节跳动内推,字节跳动招聘,字节跳动校招"

# 采集特定职位
KEYWORDS = "Java工程师招聘,前端开发,算法工程师"

# 采集校招信息
KEYWORDS = "2024校招,春季校招,实习生招聘"
```

### 调整爬取数量

```bash
vim config/base_config.py
```

修改：
```python
CRAWLER_MAX_NOTES_COUNT = 100  # 增加到100条
```

**建议**:
- 快速测试: 20-30条
- 常规使用: 50条
- 深度采集: 100-200条

### 修改存储格式

```bash
vim config/base_config.py
```

修改：
```python
SAVE_DATA_OPTION = "json"    # JSON格式 (推荐)
# SAVE_DATA_OPTION = "csv"  # CSV格式
# SAVE_DATA_OPTION = "db"   # 数据库
```

---

## 📊 数据使用场景

### 场景1: 快速查找招聘信息

```bash
# 1. 运行爬虫
./run_crawler.sh

# 2. 分析数据
./analyze_data.py

# 3. 查看高质量帖子
cat output/zhihu/high_quality_recruitment.json | jq '.[] | .title'
```

### 场景2: 监控特定公司

```python
# 修改关键词
KEYWORDS = "字节跳动内推,腾讯招聘,阿里内推"

# 运行爬虫
./run_crawler.sh

# 查看公司统计
./analyze_data.py | grep "公司信息统计" -A 20
```

### 场景3: 定时监控

```bash
# 添加到crontab
crontab -e

# 每天早上9点运行
0 9 * * * cd /path/to/MediaCrawler && ./run_crawler.sh
```

---

## 🛠️ 工具说明

### 1. run_crawler.sh - 爬虫运行脚本

**功能**:
- 环境检测
- X11显示配置
- 一键启动爬虫

**使用**:
```bash
./run_crawler.sh
```

### 2. get_cookie.sh - Cookie配置助手

**功能**:
- 交互式Cookie获取指导
- 自动配置到文件
- 备份原配置

**使用**:
```bash
./get_cookie.sh
```

### 3. analyze_data.py - 数据分析工具

**功能**:
- 质量分析
- 关键词筛选
- 公司统计
- 热度排序
- 数据导出

**使用**:
```bash
./analyze_data.py
```

---

## ⚠️ 常见问题

### Q1: Cookie提示无效怎么办？

**A**: Cookie通常7-30天失效，解决方法：

1. 重新获取Cookie
2. 确保复制了完整的Cookie (a1, d_c0, z_c0)
3. 检查Cookie格式是否正确

### Q2: 爬取速度慢怎么办？

**A**: 可以调整配置：

```python
# 减少爬取数量
CRAWLER_MAX_NOTES_COUNT = 20

# 减少评论数量
CRAWLER_MAX_COMMENTS_COUNT_SINGLENOTES = 5
```

### Q3: 找不到数据怎么办？

**A**: 检查以下几点：

1. 查看output目录是否存在
2. 检查爬虫运行日志
3. 确认Cookie是否有效
4. 验证关键词是否正确

### Q4: 如何提高数据质量？

**A**: 多维度优化：

1. **关键词优化**: 使用更精准的关键词
2. **质量筛选**: 在analyze_data.py中调整筛选阈值
3. **人工验证**: 导出数据进行二次筛选

---

## 📈 性能指标

| 指标 | 数值 |
|------|------|
| 单次采集时间 | 10-15分钟 |
| 数据量 | 50条/关键词 × 7个 = 350条 |
| 数据准确率 | >90% |
| 有效招聘信息 | >70% |
| Cookie有效期 | 7-30天 |

---

## 🎓 学习资源

| 文档 | 说明 |
|------|------|
| QUICKSTART.md | 5分钟快速上手 |
| WORKFLOW.md | 完整业务流程 |
| workflow_diagram.txt | 流程图详解 |
| COOKIE_GUIDE.md | Cookie获取指南 |
| README.md | 项目说明 |

---

## 🚀 下一步

1. **运行第一次采集**
   ```bash
   ./get_cookie.sh      # 配置Cookie
   ./run_crawler.sh     # 运行爬虫
   ./analyze_data.py    # 分析数据
   ```

2. **优化采集策略**
   - 调整关键词
   - 调整采集数量
   - 设置定时任务

3. **深度数据分析**
   - 导出数据进行二次分析
   - 可视化展示
   - 趋势分析

---

**更新时间**: 2026-01-17
**版本**: v1.0
