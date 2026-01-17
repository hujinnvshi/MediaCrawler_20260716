#!/bin/bash
# 知乎Cookie获取和配置助手

echo "=========================================="
echo "   知乎招聘信息爬虫 - Cookie配置向导"
echo "=========================================="
echo ""

PROJECT_DIR="/data/pachong_20260117/MediaCrawler_20260716"
cd "$PROJECT_DIR"

echo "📋 获取知乎Cookie的步骤："
echo ""
echo "方法1: 使用浏览器开发者工具 (推荐)"
echo "-----------------------------------"
echo "1. 在浏览器打开 https://www.zhihu.com 并登录"
echo "2. 按 F12 打开开发者工具"
echo "3. 点击 'Application' (应用) 标签"
echo "4. 左侧找到 'Cookies' → 'https://www.zhihu.com'"
echo "5. 找到以下Cookie并复制它们的值："
echo "   - a1"
echo "   - d_c0"
echo "   - z_c0"
echo ""
echo "方法2: 复制所有Cookie"
echo "-----------------------------------"
echo "1. 登录知乎"
echo "2. F12 → Network (网络) 标签"
echo "3. 刷新页面，点击任意请求"
echo "4. 在右侧 'Request Headers' 中找到 'Cookie'"
echo "5. 复制整个Cookie字符串"
echo ""
echo "=========================================="
echo ""

# 提示用户输入Cookie
read -p "请粘贴你的知乎Cookie (或按Enter跳过): " user_cookie

if [ -n "$user_cookie" ]; then
    # 备份原配置
    cp config/base_config.py config/base_config.py.backup

    # 更新配置文件
    sed -i "s|^COOKIES = .*|COOKIES = \"$user_cookie\"|" config/base_config.py

    echo ""
    echo "✓ Cookie已配置到 config/base_config.py"
    echo "✓ 原配置已备份到 config/base_config.py.backup"
    echo ""
    echo "现在可以运行爬虫了："
    echo "  ./run_crawler.sh"
    echo "  或"
    echo "  source venv/bin/activate && python main.py --platform zhihu --lt cookie --type search"
else
    echo ""
    echo "⚠️  未配置Cookie"
    echo ""
    echo "你可以："
    echo "1. 手动编辑 config/base_config.py"
    echo "2. 在 COOKIES = \"\" 处填入你的Cookie"
    echo "3. 运行 ./run_crawler.sh"
fi

echo ""
echo "=========================================="
echo "💡 提示: Cookie通常有效期7-30天"
echo "💡 如提示未登录，请重新获取Cookie"
echo "=========================================="
