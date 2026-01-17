# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MediaCrawler is a Python-based web scraping framework for collecting data from Chinese social media platforms (Xiaohongshu, Douyin, Kuaishou, Bilibili, Weibo, Baidu Tieba, Zhihu). It uses Playwright for browser automation and maintains login state to avoid complex JS reverse engineering.

## Essential Commands

### Environment Setup
```bash
# Install dependencies (requires uv package manager)
uv sync

# Install browser drivers
uv run playwright install

# Note: Some platforms (Douyin, Zhihu) require Node.js >= 16.0.0
```

### Running the Crawler
```bash
# Run with default settings (reads from config/base_config.py)
uv run main.py

# Specify platform, login type, and crawler type
uv run main.py --platform xhs --lt qrcode --type search
uv run main.py --platform dy --lt cookie --type detail

# Available platforms: xhs, dy, ks, bili, wb, tieba, zhihu
# Login types: qrcode, phone, cookie
# Crawler types: search, detail, creator

# Initialize database
uv run main.py --init_db sqlite
uv run main.py --init_db mysql
```

### WebUI
```bash
# Start FastAPI server
uv run uvicorn api.main:app --port 8080 --reload
# Access at http://localhost:8080
```

### Testing
```bash
# Run tests
pytest

# Run specific test
pytest test/test_proxy_ip_pool.py

# Pre-commit hooks
pre-commit run --all-files
```

## Architecture

### Entry Point Flow
`main.py` -> `CrawlerFactory.create_crawler()` -> Platform-specific crawler (e.g., `XiaoHongShuCrawler`) -> `AbstractCrawler.start()`

### Core Abstractions
- **AbstractCrawler** (`base/base_crawler.py`): Defines interface for all platform crawlers with methods `start()`, `search()`, `launch_browser()`
- **AbstractLogin**: Defines login methods (`login_by_qrcode()`, `login_by_mobile()`, `login_by_cookies()`)
- **AbstractStore**: Defines storage interface (`store_content()`, `store_comment()`, `store_creator()`)

### Key Components

**Browser Launch**:
- Standard Playwright mode (default)
- CDP (Chrome DevTools Protocol) mode - connects to existing browser instance for better anti-detection
- Configured via `ENABLE_CDP_MODE` in `config/base_config.py`

**Platform Implementations** (`media_platform/`):
Each platform has its own directory with:
- `*_client.py`: HTTP client with signature handling
- `*_core.py`: Core data extraction logic
- `login.py`: Authentication implementation

**Storage Layer** (`store/`):
Multiple backends: CSV, JSON, SQLite, MySQL, PostgreSQL, MongoDB, Excel
- Use `db` or `sqlite` for deduplication support
- Configured via `SAVE_DATA_OPTION`

**Proxy Pool** (`proxy/`):
IP rotation support with multiple providers (kuaidaili, wandouhttp)
- Configured via `ENABLE_IP_PROXY` and related settings

### Data Flow
1. Load config from `config/base_config.py` and platform-specific configs
2. Launch browser (standard or CDP mode)
3. Authenticate (qrcode/phone/cookie) and save login state
4. Execute crawler type:
   - `search`: Scrape posts matching keywords
   - `detail`: Scrape specific post IDs from config
   - `creator`: Scrape creator profile pages
5. Parse and extract content/comments/creator info
6. Store to configured backend
7. Optional: Generate wordcloud from comments (JSON mode only)

## Configuration System

All settings in `config/base_config.py` with Chinese comments:

**Core Settings**:
- `PLATFORM`: Target platform (default: "zhihu")
- `KEYWORDS`: Comma-separated search terms
- `LOGIN_TYPE`: Authentication method ("qrcode" | "phone" | "cookie")
- `CRAWLER_TYPE`: "search" | "detail" | "creator"
- `COOKIES`: Paste cookies directly for cookie login

**Browser Settings**:
- `HEADLESS`: Run without visible browser (True for servers)
- `ENABLE_CDP_MODE`: Use existing browser via CDP (False for servers)
- `SAVE_LOGIN_STATE`: Persist authentication

**Crawler Control**:
- `CRAWLER_MAX_NOTES_COUNT`: Max posts to scrape (default: 50)
- `CRAWLER_MAX_COMMENTS_COUNT_SINGLENOTES`: Max comments per post (default: 10)
- `MAX_CONCURRENCY_NUM`: Concurrent operations (default: 1 - be conservative!)
- `ENABLE_GET_COMMENTS`: Enable comment scraping
- `ENABLE_GET_SUB_COMMENTS`: Enable nested comments

## Project Structure

```
main.py                     # Entry point, CrawlerFactory
base/                       # Abstract base classes
media_platform/             # Platform-specific implementations
  ├── xhs/                  # Xiaohongshu (Little Red Book)
  ├── dy/                   # Douyin (TikTok China)
  ├── zhihu/                # Zhihu
  └── [other platforms]
config/                     # Configuration files
store/                      # Storage backend implementations
database/                   # ORM models and session management
proxy/                      # IP proxy pool management
cache/                      # Cache abstractions (Redis, local)
tools/                      # Utilities (async file writer, CDP manager)
model/                      # Pydantic validation models
constant/                   # Platform constants and enums
cmd_arg/                    # CLI argument parsing
api/                        # FastAPI WebUI implementation
```

## Adding a New Platform

1. Create directory under `media_platform/{platform}/`
2. Implement crawler inheriting from `AbstractCrawler`
3. Implement login inheriting from `AbstractLogin`
4. Create storage implementation in `store/`
5. Add config in `config/{platform}_config.py`
6. Register in `CrawlerFactory.CRAWLERS` in `main.py`

## Important Notes

### Legal and Ethical Usage
- Licensed under NON-COMMERCIAL LEARNING LICENSE 1.1
- Respect platform terms of service and robots.txt
- Use reasonable rate limits (default `MAX_CONCURRENCY_NUM = 1`)
- Not for commercial use without MediaCrawlerPro subscription

### Platform-Specific Considerations
- Each platform has unique anti-bot measures
- Signature calculation varies per platform (some require Node.js)
- Login methods vary by platform capabilities
- Cookie format differs per platform - see `COOKIE_GUIDE.md`

### Development Tips
- All configuration has Chinese comments inline
- Project uses async/await throughout
- Browser automation requires system dependencies
- Some signatures need JS execution via `pyexecjs`
- Test with small `CRAWLER_MAX_NOTES_COUNT` values first
- Use `HEADLESS=False` for debugging login issues

### UTF-8 Encoding
The codebase handles Chinese characters extensively. The entry point (`main.py`) forces UTF-8 encoding for stdout/stderr to prevent encoding errors in non-UTF-8 terminals.
