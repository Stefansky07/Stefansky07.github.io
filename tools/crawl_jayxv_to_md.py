#!/usr/bin/env python3
"""
Download posts from https://jayxv.github.io/ as local Markdown files.

Usage examples:
  python tools/crawl_jayxv_to_md.py
  python tools/crawl_jayxv_to_md.py --limit 5 --output jayxv_md
"""

from __future__ import annotations

import argparse
import re
import time
from pathlib import Path
from typing import Iterable
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup
from markdownify import markdownify as html_to_markdown


DEFAULT_BASE_URL = "https://jayxv.github.io/"
ARTICLE_PATH_RE = re.compile(r"^/\d{4}/\d{2}/\d{2}/")
DATE_FROM_URL_RE = re.compile(r"^/(\d{4})/(\d{2})/(\d{2})/")


def fetch_text(session: requests.Session, url: str, timeout: int = 20) -> str:
    response = session.get(url, timeout=timeout)
    response.raise_for_status()
    return response.text


def discover_article_urls(session: requests.Session, base_url: str) -> list[str]:
    archives_url = urljoin(base_url, "/archives/")
    html = fetch_text(session, archives_url)
    soup = BeautifulSoup(html, "lxml")

    urls = {
        urljoin(base_url, href)
        for a in soup.select("a[href]")
        if (href := a.get("href")) and ARTICLE_PATH_RE.match(href)
    }
    return sorted(urls)


def clean_filename(name: str, max_len: int = 120) -> str:
    # Keep Unicode but remove Windows-invalid characters.
    name = re.sub(r'[\\/:*?"<>|]', "_", name).strip()
    name = re.sub(r"\s+", " ", name)
    if not name:
        name = "untitled"
    return name[:max_len]


def pick_title(soup: BeautifulSoup) -> str:
    for selector in ("h1.article-title", "h1.post-title", "article h1", "h1"):
        node = soup.select_one(selector)
        if node:
            text = node.get_text(strip=True)
            if text:
                return text

    og_title = soup.select_one('meta[property="og:title"]')
    if og_title and og_title.get("content"):
        return og_title["content"].strip()

    title_tag = soup.title
    return title_tag.get_text(strip=True) if title_tag else "untitled"


def pick_content_node(soup: BeautifulSoup):
    for selector in (
        ".article-entry",
        "article .post-content",
        "article",
        "main",
    ):
        node = soup.select_one(selector)
        if node:
            return node
    return None


def absolutize_links(container: BeautifulSoup, page_url: str) -> None:
    for tag in container.select("[href]"):
        href = tag.get("href")
        if href:
            tag["href"] = urljoin(page_url, href)

    for tag in container.select("[src]"):
        src = tag.get("src")
        if src:
            tag["src"] = urljoin(page_url, src)


def remove_noise(container: BeautifulSoup) -> None:
    for selector in ("script", "style", "noscript", ".article_copyright", ".dashang"):
        for node in container.select(selector):
            node.decompose()


def html_fragment_to_md(fragment_html: str) -> str:
    return html_to_markdown(
        fragment_html,
        heading_style="ATX",
        bullets="-",
        strip=["script", "style"],
    ).strip()


def get_target_dir(output_dir: Path, url: str, layout: str) -> Path:
    if layout == "flat":
        return output_dir

    path = urlparse(url).path
    match = DATE_FROM_URL_RE.match(path)
    if not match:
        return output_dir

    year, month, day = match.groups()
    if layout == "year":
        return output_dir / year
    return output_dir / year / month / day


def save_markdown(output_dir: Path, title: str, url: str, body_md: str, layout: str) -> Path:
    target_dir = get_target_dir(output_dir, url, layout)
    target_dir.mkdir(parents=True, exist_ok=True)

    filename = clean_filename(title) + ".md"
    output_path = target_dir / filename

    # Avoid accidental overwrite when duplicate titles exist.
    suffix = 2
    while output_path.exists():
        output_path = target_dir / f"{clean_filename(title)} ({suffix}).md"
        suffix += 1

    with output_path.open("w", encoding="utf-8", newline="\n") as f:
        f.write(f"# {title}\n\n")
        f.write(f"> Source: {url}\n\n")
        f.write(body_md)
        f.write("\n")

    return output_path


def iter_limited(items: list[str], limit: int | None) -> Iterable[str]:
    return items if limit is None else items[:limit]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Crawl jayxv.github.io posts and save each post as a Markdown file."
    )
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL, help="Blog base URL")
    parser.add_argument("--output", default="jayxv_md", help="Output folder")
    parser.add_argument(
        "--layout",
        default="year",
        choices=("year", "date", "flat"),
        help="Folder layout: year=YYYY/, date=YYYY/MM/DD/, flat=single directory",
    )
    parser.add_argument("--sleep", type=float, default=1.0, help="Delay between requests")
    parser.add_argument("--limit", type=int, default=None, help="Only download first N posts")
    parser.add_argument(
        "--skip-existing",
        action="store_true",
        help="Skip save when a file with the same title already exists",
    )
    args = parser.parse_args()

    parsed = urlparse(args.base_url)
    if not parsed.scheme or not parsed.netloc:
        raise SystemExit("Invalid --base-url. Example: https://jayxv.github.io/")

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    session = requests.Session()
    session.headers.update({"User-Agent": "blog-archiver/1.0 (+https://jayxv.github.io/)"})

    article_urls = discover_article_urls(session, args.base_url)
    print(f"Discovered {len(article_urls)} article URLs from /archives/.")
    if not article_urls:
        print("No article URLs found. Please check site structure.")
        return 1

    ok = 0
    skipped = 0
    failed = 0

    for idx, article_url in enumerate(iter_limited(article_urls, args.limit), start=1):
        try:
            html = fetch_text(session, article_url)
            soup = BeautifulSoup(html, "lxml")
            title = pick_title(soup)
            content_node = pick_content_node(soup)
            if content_node is None:
                print(f"[{idx}] FAIL: missing article body selector -> {article_url}")
                failed += 1
                continue

            content = BeautifulSoup(str(content_node), "lxml")
            remove_noise(content)
            absolutize_links(content, article_url)
            md_body = html_fragment_to_md(str(content))
            if not md_body:
                print(f"[{idx}] FAIL: empty markdown body -> {article_url}")
                failed += 1
                continue

            candidate_name = clean_filename(title) + ".md"
            if args.skip_existing and (output_dir / candidate_name).exists():
                print(f"[{idx}] SKIP: {candidate_name}")
                skipped += 1
            else:
                saved = save_markdown(output_dir, title, article_url, md_body, args.layout)
                print(f"[{idx}] OK: {saved}")
                ok += 1

            time.sleep(max(0.0, args.sleep))
        except Exception as exc:  # noqa: BLE001 - keep crawler resilient
            print(f"[{idx}] FAIL: {article_url} -> {exc}")
            failed += 1

    print(f"Done. success={ok}, skipped={skipped}, failed={failed}")
    return 0 if ok > 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
