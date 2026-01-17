#!/bin/bash
# MediaCrawler Ubuntu 运行脚本

set -e

PROJECT_DIR="/data/pachong_20260117/MediaCrawler_20260716"
cd "$PROJECT_DIR"

echo "================================"
echo "MediaCrawler 知乎招聘信息爬虫"
echo "================================"
echo ""

# 激活虚拟环境
source venv/bin/activate

# 检查 X11 显示
if [ -z "$DISPLAY" ]; then
    echo "⚠️  警告: DISPLAY 环境变量未设置"
    echo ""
    echo "如果你是通过 SSH 连接的，请："
    echo "1. 退出当前连接"
    echo "2. 使用 X11 转发重新连接: ssh -X $USER@$(hostname)"
    echo ""
    read -p "是否尝试设置 DISPLAY=:0 并继续？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export DISPLAY=:0
        echo "已设置 DISPLAY=:0"
    else
        echo "已取消"
        exit 1
    fi
fi

echo "✓ DISPLAY: $DISPLAY"
echo ""

# 测试是否能打开浏览器
echo "测试浏览器环境..."
python3 << 'EOF'
try:
    from playwright.sync_api import sync_playwright
    print("✓ Playwright 已安装")
except ImportError:
    print("✗ Playwright 未安装")
    exit(1)
EOF

echo ""
echo "================================"
echo "准备启动爬虫..."
echo "================================"
echo ""
echo "📱 请准备好知乎APP用于扫码登录"
echo ""
echo "按回车键继续或 Ctrl+C 取消..."
read

# 启动爬虫
python main.py --platform zhihu --lt qrcode --type search

echo ""
echo "================================"
echo "爬取完成！"
echo "================================"
echo "数据保存在: output/zhihu/"
echo ""
ls -lh output/zhihu/ 2>/dev/null || echo "暂无数据文件"
