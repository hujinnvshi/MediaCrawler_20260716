#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
招聘信息数据分析工具
用于分析和筛选爬取的招聘信息
"""

import json
import os
from datetime import datetime, timedelta
from collections import defaultdict
import re


class RecruitmentAnalyzer:
    """招聘信息分析器"""

    def __init__(self, data_dir="output/zhihu"):
        self.data_dir = data_dir
        self.contents = []
        self.comments = []

    def load_data(self):
        """加载爬取的数据"""
        print("📂 正在加载数据...")

        # 加载帖子数据
        search_dir = os.path.join(self.data_dir, "search")
        if os.path.exists(search_dir):
            for filename in os.listdir(search_dir):
                if filename.endswith(".json"):
                    filepath = os.path.join(search_dir, filename)
                    with open(filepath, "r", encoding="utf-8") as f:
                        data = json.load(f)
                        if isinstance(data, list):
                            self.contents.extend(data)

        # 加载评论数据
        comments_dir = os.path.join(self.data_dir, "comments")
        if os.path.exists(comments_dir):
            for filename in os.listdir(comments_dir):
                if filename.endswith(".json"):
                    filepath = os.path.join(comments_dir, filename)
                    with open(filepath, "r", encoding="utf-8") as f:
                        data = json.load(f)
                        if isinstance(data, list):
                            self.comments.extend(data)

        print(f"✓ 已加载 {len(self.contents)} 条帖子")
        print(f"✓ 已加载 {len(self.comments)} 条评论")

    def analyze_quality(self):
        """分析数据质量"""
        print("\n" + "="*60)
        print("📊 数据质量分析")
        print("="*60)

        if not self.contents:
            print("⚠️  暂无数据，请先运行爬虫")
            return

        # 统计热度分布
        high_quality = []  # 高质量
        medium_quality = []  # 中等质量
        low_quality = []  # 低质量

        for item in self.contents:
            voteup = item.get("voteup_count", 0)
            comments = item.get("comment_count", 0)

            if voteup >= 20 or comments >= 10:
                high_quality.append(item)
            elif voteup >= 5 or comments >= 3:
                medium_quality.append(item)
            else:
                low_quality.append(item)

        print(f"\n📈 质量分布:")
        print(f"  ⭐ 高质量 (点赞≥20 或 评论≥10): {len(high_quality)} 条")
        print(f"  ⭐ 中等质量 (点赞≥5 或 评论≥3): {len(medium_quality)} 条")
        print(f"  ⭐ 低质量: {len(low_quality)} 条")

        return high_quality, medium_quality, low_quality

    def filter_by_keywords(self, keywords=None, min_quality=5):
        """根据关键词和质量筛选"""
        print("\n" + "="*60)
        print("🔍 筛选招聘信息")
        print("="*60)

        if keywords is None:
            keywords = ["招聘", "内推", "校招", "实习", "工程师", "开发"]

        results = []
        for item in self.contents:
            # 检查关键词
            title = item.get("title", "")
            content = item.get("content_text", "")

            keyword_found = any(kw in title or kw in content for kw in keywords)

            # 检查质量
            voteup = item.get("voteup_count", 0)
            quality_ok = voteup >= min_quality

            if keyword_found and quality_ok:
                results.append(item)

        print(f"\n✓ 筛选条件:")
        print(f"  • 关键词: {', '.join(keywords[:5])}")
        print(f"  • 最低点赞数: {min_quality}")
        print(f"\n✓ 找到 {len(results)} 条符合条件的招聘信息")

        return results

    def extract_companies(self):
        """提取公司信息"""
        print("\n" + "="*60)
        print("🏢 公司信息统计")
        print("="*60)

        # 常见公司名
        company_keywords = [
            "字节跳动", "字节", "抖音", "TikTok",
            "腾讯", "微信",
            "阿里", "阿里巴巴", "淘宝", "支付宝", "蚂蚁",
            "美团", "美团点评",
            "京东",
            "百度",
            "华为",
            "小米",
            "网易",
            "滴滴",
            "快手",
            "B站", "哔哩哔哩",
            "拼多多",
            "携程",
            "京东",
        ]

        company_stats = defaultdict(int)
        company_posts = defaultdict(list)

        for item in self.contents:
            text = item.get("title", "") + " " + item.get("content_text", "")
            for company in company_keywords:
                if company in text:
                    company_stats[company] += 1
                    company_posts[company].append(item)

        # 排序
        sorted_companies = sorted(company_stats.items(), key=lambda x: x[1], reverse=True)

        print(f"\n📊 招聘信息Top 10公司:")
        for i, (company, count) in enumerate(sorted_companies[:10], 1):
            print(f"  {i:2d}. {company:12s} - {count:3d} 条")

        return dict(company_posts)

    def show_top_posts(self, posts=None, n=10):
        """展示热门帖子"""
        print("\n" + "="*60)
        print(f"🔥 热门招聘帖 Top {n}")
        print("="*60)

        if posts is None:
            posts = self.contents

        # 按热度排序
        sorted_posts = sorted(
            posts,
            key=lambda x: x.get("voteup_count", 0),
            reverse=True
        )[:n]

        for i, post in enumerate(sorted_posts, 1):
            title = post.get("title", "")[:50]
            voteup = post.get("voteup_count", 0)
            comments = post.get("comment_count", 0)
            author = post.get("user_nickname", "未知")
            url = post.get("content_url", "")

            print(f"\n{i}. {title}")
            print(f"   👍 {voteup} 点赞  |  💬 {comments} 评论  |  👤 {author}")
            print(f"   🔗 {url[:80]}")

    def show_recent_posts(self, days=7, n=10):
        """展示最近的帖子"""
        print("\n" + "="*60)
        print(f"📅 最近 {days} 天的招聘信息 (Top {n})")
        print("="*60)

        now = int(datetime.now().timestamp())
        cutoff = now - (days * 86400)

        recent_posts = []
        for item in self.contents:
            created_time = item.get("created_time", 0)
            if created_time >= cutoff:
                recent_posts.append(item)

        # 按时间排序
        recent_posts.sort(key=lambda x: x.get("created_time", 0), reverse=True)

        print(f"\n✓ 找到 {len(recent_posts)} 条最近 {days} 天的帖子")

        for i, post in enumerate(recent_posts[:n], 1):
            title = post.get("title", "")[:50]
            created = post.get("created_time", 0)
            if created:
                date_str = datetime.fromtimestamp(created).strftime("%Y-%m-%d %H:%M")
            else:
                date_str = "未知"
            voteup = post.get("voteup_count", 0)

            print(f"\n{i}. {title}")
            print(f"   📅 {date_str}  |  👍 {voteup} 点赞")

    def export_filtered_data(self, posts, filename="filtered_recruitment.json"):
        """导出筛选后的数据"""
        output_path = os.path.join(self.data_dir, filename)

        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(posts, f, ensure_ascii=False, indent=2)

        print(f"\n✓ 已导出 {len(posts)} 条数据到 {output_path}")

    def generate_report(self):
        """生成完整分析报告"""
        print("\n" + "="*60)
        print("📋 招聘信息分析报告")
        print("="*60)
        print(f"生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("="*60)

        # 1. 质量分析
        high, medium, low = self.analyze_quality()

        # 2. 关键词筛选
        filtered = self.filter_by_keywords(min_quality=5)

        # 3. 公司统计
        company_posts = self.extract_companies()

        # 4. 热门帖子
        self.show_top_posts(filtered[:20])

        # 5. 最近帖子
        self.show_recent_posts(days=7, n=10)

        # 6. 导出高质量数据
        if high:
            self.export_filtered_data(high, "high_quality_recruitment.json")

        print("\n" + "="*60)
        print("✓ 分析完成！")
        print("="*60)


def main():
    """主函数"""
    print("""
╔══════════════════════════════════════════════════════════╗
║          招聘信息数据分析工具 v1.0                      ║
║          Recruitment Data Analyzer                      ║
╚══════════════════════════════════════════════════════════╝
    """)

    # 检查数据目录
    data_dir = "output/zhihu"
    if not os.path.exists(data_dir):
        print(f"⚠️  数据目录不存在: {data_dir}")
        print("\n💡 请先运行爬虫采集数据:")
        print("   ./run_crawler.sh")
        print("   或")
        print("   python main.py --platform zhihu --lt cookie --type search")
        return

    # 创建分析器
    analyzer = RecruitmentAnalyzer(data_dir)

    # 加载数据
    analyzer.load_data()

    # 生成报告
    if analyzer.contents:
        analyzer.generate_report()
    else:
        print("⚠️  未找到数据，请检查爬虫是否正常运行")


if __name__ == "__main__":
    main()
