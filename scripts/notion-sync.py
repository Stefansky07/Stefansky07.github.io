#!/usr/bin/env python3
"""Sync Notion posts marked 待发布 to Markdown and write back publish metadata."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import mimetypes
import os
import re
import shutil
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from zoneinfo import ZoneInfo

NOTION_API_BASE = "https://api.notion.com/v1"
NOTION_VERSION = "2022-06-28"
TZ = ZoneInfo("Asia/Shanghai")
POSTS_DIR = Path("content/posts")
IMAGES_DIR = Path("content/images/notion")


def _request(method: str, url: str, token: str | None = None, payload: dict | None = None, raw: bool = False):
    headers = {}
    if token:
        headers["Authorization"] = f"Bearer {token}"
        headers["Notion-Version"] = NOTION_VERSION
    data = None
    if payload is not None:
        headers["Content-Type"] = "application/json"
        data = json.dumps(payload).encode("utf-8")
    last_err: Exception | None = None
    for attempt in range(3):
        req = urllib.request.Request(url, data=data, headers=headers, method=method)
        try:
            with urllib.request.urlopen(req, timeout=30) as resp:
                body = resp.read()
                if raw:
                    return body, resp.headers.get("Content-Type", "")
                return json.loads(body.decode("utf-8"))
        except urllib.error.HTTPError as err:
            detail = err.read().decode("utf-8", errors="replace")
            if err.code in (429, 500, 502, 503, 504) and attempt < 2:
                retry_after = err.headers.get("Retry-After") if err.headers else None
                delay = float(retry_after) if (retry_after and retry_after.isdigit()) else 1.5 * (attempt + 1)
                time.sleep(min(delay, 30.0))
                last_err = RuntimeError(f"HTTP {err.code}: {detail}")
                continue
            raise RuntimeError(f"HTTP {err.code} for {url}: {detail}") from err
        except (urllib.error.URLError, OSError) as err:
            last_err = err
            if attempt < 2:
                time.sleep(1.5 * (attempt + 1))
                continue
            raise RuntimeError(f"Network error for {url}: {err}") from err
    raise RuntimeError(f"Request failed for {url}: {last_err}")


def query_pending(token: str, db_id: str) -> list[dict]:
    pages: list[dict] = []
    cursor: str | None = None
    while True:
        payload: dict = {
            "filter": {
                "or": [
                    {"property": "状态", "status": {"equals": "待发布"}},
                    {"property": "状态", "status": {"equals": "撤回"}},
                ]
            },
            "page_size": 100,
        }
        if cursor:
            payload["start_cursor"] = cursor
        res = _request("POST", f"{NOTION_API_BASE}/databases/{db_id}/query", token, payload)
        pages.extend(res.get("results", []))
        if not res.get("has_more"):
            return pages
        cursor = res.get("next_cursor")


def plain_text(items: list[dict]) -> str:
    return "".join(item.get("plain_text", "") for item in items or [])


def normalize_slug(raw_slug: str, title: str, page_id: str, date_str: str, used_slugs: set[str]) -> str:
    short_id = page_id.replace("-", "")[:6].lower()
    candidate = raw_slug.strip().lower() or title.strip().lower()
    slug = re.sub(r"[^a-z0-9-]+", "-", candidate).strip("-")[:120].rstrip("-")
    if not slug:
        compact_date = date_str.replace("-", "")[:8] or dt.datetime.now(TZ).strftime("%Y%m%d")
        slug = f"post-{compact_date}-{short_id}"
    elif not raw_slug.strip() and ((POSTS_DIR / f"{slug}.md").exists() or slug in used_slugs):
        slug = f"{slug[:110].rstrip('-')}-{short_id}"
    if slug in used_slugs:
        raise ValueError(f"Duplicate slug in batch: {slug}")
    used_slugs.add(slug)
    return slug


def yaml_quote(value: str) -> str:
    escaped = value.replace("\\", "\\\\").replace('"', '\\"').replace("\r", " ").replace("\n", " ")
    return f'"{escaped}"'


def render_frontmatter(title: str, description: str, date_str: str, tag: str, tags: list[str]) -> str:
    lines = [
        "---",
        f"title: {yaml_quote(title)}",
        f"description: {yaml_quote(description)}",
        f"date: {date_str}",
    ]
    if tag:
        lines.append(f"tag: {yaml_quote(tag)}")
    if tags:
        lines.append("tags:")
        lines.extend(f"  - {yaml_quote(t)}" for t in tags)
    lines.append("---")
    return "\n".join(lines) + "\n\n"


def fetch_blocks(token: str, block_id: str) -> list[dict]:
    blocks: list[dict] = []
    cursor: str | None = None
    while True:
        qs = "?page_size=100" + (f"&start_cursor={urllib.parse.quote(cursor)}" if cursor else "")
        res = _request("GET", f"{NOTION_API_BASE}/blocks/{block_id}/children{qs}", token)
        for blk in res.get("results", []):
            if blk.get("has_children"):
                blk["_children"] = fetch_blocks(token, blk["id"])
            blocks.append(blk)
        if not res.get("has_more"):
            return blocks
        cursor = res.get("next_cursor")


def render_rich_text(items: list[dict]) -> str:
    out: list[str] = []
    for item in items or []:
        if item.get("type") == "equation":
            expr = item.get("equation", {}).get("expression", "")
            out.append(f"${expr}$")
            continue
        text = item.get("plain_text", "")
        if not text:
            continue
        ann = item.get("annotations", {})
        href = item.get("href")
        if ann.get("code"):
            ticks = "``" if "`" in text else "`"
            formatted = f"{ticks}{text}{ticks}"
        else:
            formatted = text
            if ann.get("bold"):
                formatted = f"**{formatted}**"
            if ann.get("italic"):
                formatted = f"*{formatted}*"
            if ann.get("strikethrough"):
                formatted = f"~~{formatted}~~"
        if href:
            formatted = f"[{formatted}]({href})"
        out.append(formatted)
    return "".join(out)


def _guess_ext(url: str, content_type: str) -> str:
    path_ext = Path(urllib.parse.urlparse(url).path).suffix.lower()
    if path_ext in {".png", ".jpg", ".jpeg", ".webp", ".gif", ".svg"}:
        return path_ext
    mime = content_type.split(";")[0].strip().lower()
    guessed = mimetypes.guess_extension(mime) or ".png"
    return ".jpg" if guessed == ".jpe" else guessed


def download_image(url: str, slug: str, idx: int, dry_run: bool) -> str:
    if dry_run:
        ext = _guess_ext(url, "")
        return f"../images/notion/{slug}/img-{idx}{ext}"
    raw_bytes, ctype = _request("GET", url, raw=True)
    ext = _guess_ext(url, ctype)
    rel_name = f"img-{idx}{ext}"
    dest = IMAGES_DIR / slug / rel_name
    content_root = Path("content").resolve()
    if not dest.parent.resolve().is_relative_to(content_root):
        raise ValueError(f"Unsafe image path outside content/: {dest}")
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and dest.is_symlink():
        raise ValueError(f"Refusing symlink destination: {dest}")
    dest.write_bytes(raw_bytes)
    return f"../images/notion/{slug}/{rel_name}"


def _render_table(rows: list[dict], has_header: bool) -> str:
    rendered = []
    for row in rows:
        cells = row.get("table_row", {}).get("cells", [])
        rendered.append("| " + " | ".join(" ".join(render_rich_text(c).splitlines()).replace("|", "\\|") for c in cells) + " |")
    if not rendered:
        return ""
    cols = max(len(r.get("table_row", {}).get("cells", [])) for r in rows)
    sep = "| " + " | ".join(["---"] * cols) + " |"
    if has_header:
        return "\n".join([rendered[0], sep, *rendered[1:]]) + "\n\n"
    blank = "| " + " | ".join([""] * cols) + " |"
    return "\n".join([blank, sep, *rendered]) + "\n\n"


def _prefix_lines(text: str, prefix: str) -> str:
    return "".join(f"{prefix}{ln}\n" if ln else "\n" for ln in text.splitlines())


def blocks_to_markdown(blocks: list[dict], slug: str, dry_run: bool, img_counter: list[int] | None = None) -> str:
    counter = img_counter if img_counter is not None else [0]
    parts: list[str] = []
    for idx, blk in enumerate(blocks):
        btype = blk.get("type", "")
        data = blk.get(btype, {})
        children = blk.get("_children", [])
        if btype == "paragraph":
            txt = render_rich_text(data.get("rich_text", []))
            if txt:
                parts.append(f"{txt}\n\n")
        elif btype in ("heading_1", "heading_2", "heading_3"):
            parts.append(f"{'#' * int(btype[-1])} {render_rich_text(data.get('rich_text', []))}\n\n")
        elif btype in ("bulleted_list_item", "numbered_list_item", "to_do"):
            marker = "1. " if btype == "numbered_list_item" else ("- [x] " if data.get("checked") else "- [ ] ") if btype == "to_do" else "- "
            parts.append(f"{marker}{render_rich_text(data.get('rich_text', []))}\n")
            if children:
                child_indent = "   " if btype == "numbered_list_item" else "  "
                parts.append(_prefix_lines(blocks_to_markdown(children, slug, dry_run, counter).rstrip(), child_indent))
            nxt = blocks[idx + 1].get("type", "") if idx + 1 < len(blocks) else ""
            if nxt not in ("bulleted_list_item", "numbered_list_item", "to_do"):
                parts.append("\n")
            continue
        elif btype in ("quote", "callout"):
            body = render_rich_text(data.get("rich_text", []))
            if children:
                body = (body + "\n\n" + blocks_to_markdown(children, slug, dry_run, counter)).strip()
            lines = body.splitlines() or [""]
            parts.append("".join(f"> {ln}\n" if ln else ">\n" for ln in lines) + "\n")
            continue
        elif btype == "code":
            lang = (data.get("language") or "").replace("plain text", "").strip()
            code_txt = plain_text(data.get("rich_text", []))
            fence = "````" if "```" in code_txt else "```"
            parts.append(f"{fence}{lang}\n{code_txt}\n{fence}\n\n")
        elif btype == "divider":
            parts.append("---\n\n")
        elif btype == "equation":
            parts.append(f"$$\n{data.get('expression', '')}\n$$\n\n")
        elif btype == "table":
            parts.append(_render_table(children, bool(data.get("has_column_header", True))))
            continue
        elif btype == "image":
            src = data.get("file", {}).get("url") or data.get("external", {}).get("url") or ""
            if src:
                counter[0] += 1
                local_img = download_image(src, slug, counter[0], dry_run)
                cap = " ".join(re.sub(r"([\\\[\]])", r"\\\1", plain_text(data.get("caption", []))).splitlines())
                parts.append(f"![{cap}]({local_img})\n\n")
        if children and btype not in ("table", "quote", "callout"):
            parts.append(blocks_to_markdown(children, slug, dry_run, counter))
    return "".join(parts)


def update_page_status(
    token: str,
    page_id: str,
    status_name: str,
    note: str,
    slug: str | None = None,
    live_url: str | None = None,
    clear_url: bool = False,
) -> None:
    props: dict = {
        "状态": {"status": {"name": status_name}},
        "同步备注": {"rich_text": [{"text": {"content": note[:1800]}}]},
    }
    if slug is not None:
        props["Slug"] = {"rich_text": [{"text": {"content": slug}}]}
    if clear_url:
        props["线上链接"] = {"url": None}
    elif live_url is not None:
        props["线上链接"] = {"url": live_url}
    _request("PATCH", f"{NOTION_API_BASE}/pages/{page_id}", token, {"properties": props})


def stage_page(token: str, page: dict, site_url: str, dry_run: bool, used_slugs: set[str]) -> dict | None:
    page_id = page["id"]
    props = page.get("properties", {})
    title = plain_text(props.get("标题", {}).get("title", [])) or "未命名文章"
    desc = plain_text(props.get("摘要", {}).get("rich_text", [])) or title
    date_obj = props.get("发布日期", {}).get("date") or {}
    date_str = (date_obj.get("start") or dt.datetime.now(TZ).strftime("%Y-%m-%d"))[:10]
    tag = (props.get("分类", {}).get("select") or {}).get("name", "")
    tags = [t["name"] for t in props.get("标签", {}).get("multi_select", []) if t.get("name")]
    raw_slug = plain_text(props.get("Slug", {}).get("rich_text", []))
    slug = normalize_slug(raw_slug, title, page_id, date_str, used_slugs)
    blocks = fetch_blocks(token, page_id)
    md_body = blocks_to_markdown(blocks, slug, dry_run).strip() + "\n"
    content = render_frontmatter(title, desc, date_str, tag, tags) + md_body
    post_path = POSTS_DIR / f"{slug}.md"
    live_url = f"{site_url.rstrip('/')}/posts/{slug}/"
    if dry_run:
        print(f"[DRY-RUN] {post_path} -> {live_url}")
        print("\n".join(content.splitlines()[:25]))
        return None
    POSTS_DIR.mkdir(parents=True, exist_ok=True)
    post_path.write_text(content, encoding="utf-8")
    print(f"Staged: {post_path} -> {live_url}")
    return {"action": "publish", "page_id": page_id, "slug": slug, "live_url": live_url}


def stage_unpublish(page: dict, dry_run: bool) -> dict | None:
    page_id = page["id"]
    props = page.get("properties", {})
    title = plain_text(props.get("标题", {}).get("title", [])) or ""
    date_obj = props.get("发布日期", {}).get("date") or {}
    date_str = (date_obj.get("start") or dt.datetime.now(TZ).strftime("%Y-%m-%d"))[:10]
    raw_slug = plain_text(props.get("Slug", {}).get("rich_text", []))
    candidate = raw_slug.strip().lower() or title.strip().lower()
    slug = re.sub(r"[^a-z0-9-]+", "-", candidate).strip("-")[:120].rstrip("-")
    if not slug:
        compact_date = date_str.replace("-", "")[:8] or dt.datetime.now(TZ).strftime("%Y%m%d")
        slug = f"post-{compact_date}-{page_id.replace('-', '')[:6].lower()}"
    post_path = POSTS_DIR / f"{slug}.md"
    img_dir = IMAGES_DIR / slug
    content_root = Path("content").resolve()
    if not post_path.parent.resolve().is_relative_to(content_root) or not img_dir.parent.resolve().is_relative_to(content_root):
        raise ValueError(f"Unsafe unpublish path for slug: {slug}")
    if dry_run:
        print(f"[DRY-RUN UNPUBLISH] {post_path}")
        return None
    if post_path.exists() and not post_path.is_symlink():
        post_path.unlink()
    if img_dir.exists() and img_dir.is_dir() and not img_dir.is_symlink():
        shutil.rmtree(img_dir)
    print(f"Staged unpublish: {slug}")
    return {"action": "unpublish", "page_id": page_id, "slug": slug}


def _ack_record(token: str, rec: dict, now_str: str) -> None:
    if rec.get("action") == "unpublish":
        update_page_status(token, rec["page_id"], "已撤回", f"已撤回于 {now_str}", clear_url=True)
        print(f"Acked unpublish: {rec['slug']}")
        return
    update_page_status(token, rec["page_id"], "已上线", f"已同步于 {now_str}", slug=rec["slug"], live_url=rec["live_url"])
    print(f"Acked: {rec['slug']} -> {rec['live_url']}")


def ack_manifest(token: str, manifest_path: Path) -> int:
    records = json.loads(manifest_path.read_text(encoding="utf-8"))
    now_str = dt.datetime.now(TZ).strftime("%Y-%m-%d %H:%M")
    had_err = False
    for rec in records:
        try:
            _ack_record(token, rec, now_str)
        except Exception as exc:
            had_err = True
            print(f"Ack failed for {rec.get('page_id')}: {exc}", file=sys.stderr)
    return 1 if had_err else 0


def _write_gh_output(output_path: str, pending: bool) -> None:
    if output_path:
        with open(output_path, "a", encoding="utf-8") as f:
            f.write(f"pending={'true' if pending else 'false'}\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync Notion blog posts marked 待发布 or 撤回.")
    parser.add_argument("--dry-run", action="store_true", help="Preview sync/unpublish without writing files or Notion.")
    parser.add_argument("--manifest", help="Write staged sync records to JSON and defer Notion writeback until --ack.")
    parser.add_argument("--ack", help="Acknowledge staged manifest JSON back to Notion.")
    parser.add_argument("--github-output", default="", help="Append pending=true/false to GitHub Actions output file.")
    args = parser.parse_args()
    token = os.environ.get("NOTION_TOKEN", "").strip()
    if not token:
        print("NOTION_TOKEN is required.", file=sys.stderr)
        return 1
    if args.ack:
        return ack_manifest(token, Path(args.ack))
    db_id = os.environ.get("NOTION_BLOG_DB_ID", "").strip()
    site_url = os.environ.get("SITE_URL", "https://stefansky07.github.io").strip()
    if not db_id:
        print("NOTION_BLOG_DB_ID is required.", file=sys.stderr)
        return 1
    pages = query_pending(token, db_id)
    if not pages:
        print("No pending Notion posts.")
        _write_gh_output(args.github_output, False)
        return 0
    staged: list[dict] = []
    used_slugs: set[str] = set()
    had_err = False
    for page in pages:
        status_name = (page.get("properties", {}).get("状态", {}).get("status") or {}).get("name", "")
        try:
            rec = stage_unpublish(page, args.dry_run) if status_name == "撤回" else stage_page(token, page, site_url, args.dry_run, used_slugs)
            if rec:
                staged.append(rec)
        except Exception as exc:
            had_err = True
            print(f"Failed to sync {page.get('id')}: {exc}", file=sys.stderr)
            if not args.dry_run:
                try:
                    update_page_status(token, page["id"], "发布失败", f"同步失败: {exc}")
                except Exception as note_err:
                    print(f"Failed to write error note: {note_err}", file=sys.stderr)
    _write_gh_output(args.github_output, bool(staged))
    if args.manifest and not args.dry_run:
        Path(args.manifest).write_text(json.dumps(staged, ensure_ascii=False), encoding="utf-8")
    elif not args.manifest and not args.dry_run and staged:
        now_str = dt.datetime.now(TZ).strftime("%Y-%m-%d %H:%M")
        for rec in staged:
            _ack_record(token, rec, now_str)
    return 1 if had_err else 0


if __name__ == "__main__":
    raise SystemExit(main())
