---
title: "你好，新博客"
description: "新博客上线测试文章，用于验证排版、数学公式、代码块与 Notion 一键发布流程。"
date: 2026-11-26
tag: "折腾"
tags:
  - "Blog"
  - "Notion"
---

这是一篇用于验证新博客样式与渲染能力的测试文章，原站所有历史文章已下线清空。

## 为什么升级新博客

新的静态站点采用极简纸面网格排版，构建期完成公式预渲染、代码高亮与站内搜索索引 `/search.json` 生成，日常只需在 Notion 撰写并一键触发发布。

> 先跑通最小闭环，再逐步把 Notion 里的日常笔记与安全研究文章迁移过来。

## 排版与公式测试

行内公式 $E = mc^2$ 与矩阵范数示例：

$$\mathcal{L}(\theta) = \mathbb{E}_{(x, y) \sim \mathcal{D}} \left[ \ell\big(f_\theta(x), y\big) \right] + \frac{\lambda}{2} \|\theta\|_2^2$$

```python
def publish_status(page_title: str) -> str:
    return f"Ready to publish: {page_title}"
```

## 后续发布方式

后续在 Notion「Blog」库中写好文章后，将状态切换为 `待发布`，即可自动同步生成本文所在的 `content/posts/` 文件并构建上线。
