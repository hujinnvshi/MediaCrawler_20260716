#!/bin/bash
# Mac环境快速检查脚本

echo "=========================================="
echo "   MediaCrawler Mac环境检查工具"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_item() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

warn_item() {
    echo -e "${YELLOW}⚠️  ${NC}$1"
}

echo "📋 系统信息:"
echo "----------------------------------------"
echo "操作系统: $(sw_vers -productName) $(sw_vers -productVersion)"
echo "架构: $(uname -m)"
echo ""

echo "🔍 Python环境检查:"
echo "----------------------------------------"

# 检查Python 3
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    if [ "$PYTHON_MAJOR" -ge 3 ] && [ "$PYTHON_MINOR" -ge 10 ]; then
        echo -e "${GREEN}✓${NC} Python $PYTHON_VERSION (符合要求: ≥3.10)"
    else
        echo -e "${YELLOW}⚠️  Python $PYTHON_VERSION (建议升级到 3.10+)"
    fi
else
    echo -e "${RED}✗${NC} Python 3 未安装"
    echo "   安装: brew install python@3.11"
fi

echo ""

echo "🔧 依赖工具检查:"
echo "----------------------------------------"

# 检查git
if command -v git &> /dev/null; then
    echo -e "${GREEN}✓${NC} Git 已安装: $(git --version | awk '{print $3}')"
else
    echo -e "${RED}✗${NC} Git 未安装"
    echo "   安装: xcode-select --install"
fi

# 检查Chrome
if [ -d "/Applications/Google Chrome.app" ]; then
    echo -e "${GREEN}✓${NC} Chrome 浏览器已安装"
else
    echo -e "${YELLOW}⚠️  Chrome 浏览器未找到"
    echo "   下载: https://www.google.com/chrome/"
fi

# 检查Homebrew
if command -v brew &> /dev/null; then
    echo -e "${GREEN}✓${NC} Homebrew 已安装: $(brew --version | awk '{print $2}')"
else
    echo -e "${YELLOW}⚠️  Homebrew 未安装 (可选)"
    echo "   安装: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi

echo ""

echo "📂 项目文件检查:"
echo "----------------------------------------"

PROJECT_FILES=(
    "config/base_config.py:配置文件"
    "main.py:主程序"
    "requirements.txt:依赖清单"
    "run_crawler.sh:运行脚本"
    "analyze_data.py:分析工具"
)

for item in "${PROJECT_FILES[@]}"; do
    FILE="${item%%:*}"
    DESC="${item##*:}"

    if [ -f "$FILE" ]; then
        echo -e "${GREEN}✓${NC} $DESC ($FILE)"
    else
        echo -e "${RED}✗${NC} $DESC ($FILE) - 文件不存在"
    fi
done

echo ""

echo "🔐 配置检查:"
echo "----------------------------------------"

if [ -f "config/base_config.py" ]; then
    # 检查平台配置
    PLATFORM=$(grep "^PLATFORM = " config/base_config.py | cut -d'"' -f2)
    echo -e "${GREEN}✓${NC} 平台配置: $PLATFORM"

    # 检查登录方式
    LOGIN_TYPE=$(grep "^LOGIN_TYPE = " config/base_config.py | cut -d'"' -f2)
    if [ "$LOGIN_TYPE" = "qrcode" ]; then
        echo -e "${GREEN}✓${NC} 登录方式: 二维码 (适合Mac)"
    elif [ "$LOGIN_TYPE" = "cookie" ]; then
        COOKIES=$(grep "^COOKIES = " config/base_config.py | cut -d'"' -f2)
        if [ -n "$COOKIES" ]; then
            echo -e "${GREEN}✓${NC} 登录方式: Cookie (已配置)"
        else
            echo -e "${YELLOW}⚠️  登录方式: Cookie (未配置)"
        fi
    fi

    # 检查无头模式
    HEADLESS=$(grep "^HEADLESS = " config/base_config.py | cut -d' ' -f3 | tr -d ' ')
    if [ "$HEADLESS" = "False" ]; then
        echo -e "${GREEN}✓${NC} 图形界面: 已启用 (会打开浏览器)"
    else
        echo -e "${YELLOW}⚠️  图形界面: 已禁用 (无头模式)"
        echo "   建议: Mac上设置为 False 以便扫码登录"
    fi
fi

echo ""

echo "📊 环境评估:"
echo "----------------------------------------"

ISSUES=0

# 检查Python版本
if ! command -v python3 &> /dev/null; then
    ISSUES=$((ISSUES + 1))
elif [ "$PYTHON_MAJOR" -lt 3 ] || [ "$PYTHON_MINOR" -lt 10 ]; then
    ISSUES=$((ISSUES + 1))
fi

# 检查Chrome
if [ ! -d "/Applications/Google Chrome.app" ]; then
    ISSUES=$((ISSUES + 1))
fi

# 检查项目文件
if [ ! -f "config/base_config.py" ]; then
    ISSUES=$((ISSUES + 1))
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ 环境检查通过！可以开始安装依赖${NC}"
    echo ""
    echo "🚀 下一步操作:"
    echo "----------------------------------------"
    echo "1. 创建虚拟环境:"
    echo "   python3 -m venv venv"
    echo ""
    echo "2. 激活虚拟环境:"
    echo "   source venv/bin/activate"
    echo ""
    echo "3. 安装依赖:"
    echo "   pip install -r requirements.txt"
    echo ""
    echo "4. 安装浏览器驱动:"
    echo "   playwright install chrome"
    echo ""
    echo "5. 运行爬虫:"
    echo "   python main.py --platform zhihu --lt qrcode --type search"
else
    echo -e "${YELLOW}⚠️  发现 $ISSUES 个问题，请先解决${NC}"
    echo ""
    echo "建议操作:"
    echo "----------------------------------------"

    if ! command -v python3 &> /dev/null; then
        echo "• 安装 Python 3:"
        echo "  brew install python@3.11"
    fi

    if [ ! -d "/Applications/Google Chrome.app" ]; then
        echo "• 安装 Chrome 浏览器:"
        echo "  https://www.google.com/chrome/"
    fi

    if [ ! -f "config/base_config.py" ]; then
        echo "• 确保在项目目录中:"
        echo "  cd MediaCrawler_20260716"
    fi
fi

echo ""
echo "=========================================="
echo "   检查完成！"
echo "=========================================="
