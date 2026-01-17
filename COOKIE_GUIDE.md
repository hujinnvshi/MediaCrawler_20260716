# 使用 Cookie 登录知乎爬虫指南

## 方法一：从浏览器获取 Cookie

### Chrome/Edge 浏览器

1. 打开 Chrome 或 Edge 浏览器
2. 访问 https://www.zhihu.com 并登录
3. 登录成功后，按 `F12` 打开开发者工具
4. 点击 `Application` 标签（或 `存储`）
5. 左侧菜单展开 `Cookies` → `https://www.zhihu.com`
6. 找到以下关键 Cookie 并复制它们的值：
   - `a1`
   - `d_c0`
   - `z_c0`

### 组合格式

将Cookie组合成以下格式：

```
a1=你的a1值; d_c0=你的d_c0值; z_c0=你的z_c0值
```

### 示例

```
a1=18c123abc456def; d_c0="AUBA1234567890-2|1234567890"; z_c0="2|4.0|abc123def456|1234567890"
```

## 方法二：使用浏览器扩展（推荐）

### EditThisCookie 扩展

1. 安装 [EditThisCookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg) 扩展
2. 登录知乎
3. 点击浏览器工具栏的 Cookie 图标
4. 点击 `导出` → 选择格式为 `Netscape` 或 `JSON`
5. 复制导出的字符串

### 导出的格式示例

```
# Netscape format
.zhihu.com	TRUE	/	FALSE	1735689600	a1	18c123abc456def
.zhihu.com	TRUE	/	FALSE	1735689600	d_c0	AUBA1234567890-2|1234567890
.zhihu.com	TRUE	/	FALSE	1735689600	z_c0	2|4.0|abc123def456|1234567890
```

转换为：
```
a1=18c123abc456def; d_c0=AUBA1234567890-2|1234567890; z_c0=2|4.0|abc123def456|1234567890
```

## 应用 Cookie

### 方式1：直接修改配置文件

编辑 `config/base_config.py`：

```python
LOGIN_TYPE = "cookie"
COOKIES = "你复制的Cookie字符串"
```

### 方式2：使用环境变量（推荐，更安全）

```bash
export ZHIHU_COOKIES="你的Cookie字符串"
python main.py --platform zhihu --lt cookie --type search
```

或者创建 `.env` 文件：

```bash
echo "ZHIHU_COOKIES='你的Cookie字符串'" > .env
```

然后修改 `config/base_config.py`：

```python
import os
LOGIN_TYPE = "cookie"
COOKIES = os.getenv("ZHIHU_COOKIES", "")
```

## Cookie 有效期

- 知乎 Cookie 通常有效期：**7-30天**
- 如果爬虫提示未登录，需要重新获取 Cookie
- 建议定期更新 Cookie

## 验证 Cookie 是否有效

运行以下 Python 脚本：

```python
import httpx

cookies_str = "你的Cookie字符串"
cookies = {}
for item in cookies_str.split('; '):
    key, value = item.split('=', 1)
    cookies[key] = value

response = httpx.get("https://www.zhihu.com/api/me", cookies=cookies)
print(response.json())
```

如果返回用户信息，说明 Cookie 有效。

## 常见问题

### Q: Cookie 提示无效？
A: 可能是：
1. Cookie 过期了，重新获取
2. 格式不对，检查是否有引号或多余空格
3. 缺少必要的 Cookie 字段（a1, d_c0, z_c0）

### Q: 爬取一段时间后被踢出登录？
A: Cookie 失效了，需要重新获取

### Q: 如何避免频繁更新 Cookie？
A: 可以使用二维码登录，登录态会保存到浏览器文件，有效期更长

## 推荐方案

**优先使用**：`LOGIN_TYPE = "qrcode"` + X11 转发
**备选方案**：`LOGIN_TYPE = "cookie"`（适合无图形界面环境）
