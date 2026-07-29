#!/usr/bin/env python3
"""知识库分析器 - 扫描 Markdown 文件，生成统计报告。

用法：
    python kb_analyzer.py                        # 扫描当前目录
    python kb_analyzer.py /path/to/vault         # 扫描指定目录
    python kb_analyzer.py --json                 # JSON 格式输出
    python kb_analyzer.py --sort words           # 按字数排序
"""

import os
import re
import json
import argparse
from pathlib import Path
from collections import defaultdict


def parse_markdown(filepath: str) -> dict:
    """解析单个 Markdown 文件，提取元数据和统计信息。"""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        return {"file": str(filepath), "error": str(e)}

    # YAML frontmatter 提取
    frontmatter = {}
    fm_match = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    body = content
    if fm_match:
        body = content[fm_match.end() :]
        for line in fm_match.group(1).strip().split("\n"):
            if ":" in line:
                key, _, val = line.partition(":")
                frontmatter[key.strip()] = val.strip().strip('"').strip("'")

    # 字数统计（中英文混合）
    chinese_chars = len(re.findall(r"[一-鿿]", body))
    english_words = len(re.findall(r"[a-zA-Z]+", body))
    total_lines = body.count("\n")

    # 链接统计
    wiki_links = re.findall(r"\[\[([^\]|#]+)", body)  # [[target]]
    md_links = re.findall(r"\[([^\]]+)\]\(([^)]+)\)", body)  # [text](url)

    # 标题层级
    headings = re.findall(r"^(#{1,6})\s+(.+)", body, re.MULTILINE)

    # 标签
    tags = re.findall(r"#([\w一-鿿\-/]+)", body)

    # 代码块
    code_blocks = len(re.findall(r"```[\s\S]*?```", body))

    return {
        "file": str(filepath),
        "frontmatter": frontmatter,
        "stats": {
            "chinese_chars": chinese_chars,
            "english_words": english_words,
            "total_words": chinese_chars + english_words,
            "lines": total_lines,
        },
        "links": {
            "wiki_links": len(wiki_links),
            "wiki_targets": list(set(wiki_links)),
            "md_links": len(md_links),
        },
        "headings": len(headings),
        "heading_depth": max((len(h[0]) for h in headings), default=0),
        "tags": list(set(tags)),
        "tag_count": len(set(tags)),
        "code_blocks": code_blocks,
        "size_kb": round(os.path.getsize(filepath) / 1024, 1),
    }


def scan_vault(root_dir: str, extensions: tuple = (".md",)) -> list:
    """递归扫描目录下所有 Markdown 文件。"""
    results = []
    for dirpath, _, filenames in os.walk(root_dir):
        # 跳过隐藏目录
        if any(part.startswith(".") for part in Path(dirpath).parts):
            continue
        for fname in filenames:
            if fname.endswith(extensions):
                results.append(parse_markdown(os.path.join(dirpath, fname)))
    return results


def generate_report(results: list, fmt: str = "text", sort_by: str = "file") -> str:
    """生成汇总报告。"""
    valid = [r for r in results if "error" not in r]
    errors = [r for r in results if "error" in r]

    # 排序
    if sort_by == "words":
        valid.sort(key=lambda r: r["stats"]["total_words"], reverse=True)
    elif sort_by == "links":
        valid.sort(key=lambda r: r["links"]["wiki_links"] + r["links"]["md_links"], reverse=True)

    if fmt == "json":
        return json.dumps({
            "summary": {
                "total_files": len(results),
                "total_words": sum(r["stats"]["total_words"] for r in valid),
                "total_links": sum(r["links"]["wiki_links"] + r["links"]["md_links"] for r in valid),
                "total_tags": sum(r["tag_count"] for r in valid),
                "all_tags": sorted(set(t for r in valid for t in r["tags"])),
                "errors": len(errors),
            },
            "files": valid,
        }, ensure_ascii=False, indent=2)

    # 文本报告
    total_words = sum(r["stats"]["total_words"] for r in valid)
    total_links = sum(r["links"]["wiki_links"] + r["links"]["md_links"] for r in valid)
    all_tags = sorted(set(t for r in valid for t in r["tags"]))

    lines = [
        "=" * 60,
        "         📊 知识库分析报告",
        "=" * 60,
        f"扫描文件: {len(results)} 个 | 错误: {len(errors)} 个",
        f"总字数:   {total_words:,} (中文 + 英文)",
        f"总链接:   {total_links:,} (Wiki: {sum(r['links']['wiki_links'] for r in valid)}, MD: {sum(r['links']['md_links'] for r in valid)})",
        f"标签总数: {len(all_tags)} 个 → {' '.join('#t/' + t for t in all_tags[:20])}{'...' if len(all_tags) > 20 else ''}",
        "=" * 60,
        "",
        f"{'文件':<45} {'字数':>8} {'链接':>6} {'标题':>5} {'标签':>4} {'代码块':>6}",
        "-" * 80,
    ]

    for r in valid:
        s = r["stats"]
        l = r["links"]
        rel_path = os.path.relpath(r["file"])
        display = rel_path if len(rel_path) <= 43 else "..." + rel_path[-40:]
        lines.append(
            f"{display:<45} {s['total_words']:>6,}  "
            f"{l['wiki_links'] + l['md_links']:>4}  {r['headings']:>4}  "
            f"{r['tag_count']:>3}  {r['code_blocks']:>5}"
        )

    # 孤立页面检查
    all_targets = set()
    for r in valid:
        all_targets |= set(r["links"]["wiki_targets"])
    source_names = {os.path.splitext(os.path.basename(r["file"]))[0] for r in valid}
    orphans = source_names - all_targets - {"index", "日报模板"}

    if orphans:
        lines.append("")
        lines.append("⚠️  可能的孤立页面（没有被任何页面链接）：")
        for o in sorted(orphans):
            lines.append(f"    - [[{o}]]")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="知识库 Markdown 分析器")
    parser.add_argument("path", nargs="?", default=".", help="知识库目录路径")
    parser.add_argument("--json", action="store_true", help="JSON 格式输出")
    parser.add_argument("--sort", choices=["file", "words", "links"], default="file", help="排序方式")
    args = parser.parse_args()

    if not os.path.isdir(args.path):
        print(f"❌ 目录不存在: {args.path}")
        return

    print(f"🔍 正在扫描: {os.path.abspath(args.path)} ...")
    results = scan_vault(args.path)
    report = generate_report(results, fmt="json" if args.json else "text", sort_by=args.sort)
    print(report)


if __name__ == "__main__":
    main()
