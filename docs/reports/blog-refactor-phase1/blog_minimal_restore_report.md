# blog_minimal_restore_report

生成时间：2026-04-22

## 1. 恢复基线

本次恢复基线选为：**你本地手动 `npx hexo deploy` 后可复现的本地有效状态**，对应证据为：

1. `git reflog` 中 `2026-04-22` 的本地发布链路记录；
2. 本地当前 `source/_posts/ctf_publish_ready/**` 的已整理 front-matter 变更；
3. 本次按该状态重新执行 `npx hexo clean && npx hexo generate` 后，`public/categories/index.html` 恢复主结构。

说明：该基线不是“新增功能状态”，而是“你已验证正常的本地内容结构状态”。

## 2. 实际修改/提交文件

本轮仅纳入“恢复分类结构”必需文件：

1. `source/_posts/ctf_publish_ready/**`（front-matter 整理结果，约 103 篇）
2. `source/_posts/大模型安全-导读.md`
3. `source/_posts/逆向学习笔记-原理研究-导读.md`
4. `source/_posts/逆向学习笔记-应用-导读.md`

未纳入：

- skill / blog_report 工作流代码
- tools 辅助脚本
- 主题与样式
- 新页面设计或新功能

## 3. 之前会乱的原因

根因：**远端 Actions 使用的 `hexo-src` 输入状态，落后于你本地实际生效状态**。

具体表现：

1. 本地已整理的 front-matter 没有完整进入 `hexo-src`；
2. Actions clean build 时只看到远端旧状态；
3. 导致前台退化为“主结构缺失/残留旧桶”。

## 4. 当前恢复结果

本地执行：

1. `npx hexo clean`
2. `npx hexo generate`

检查结果：

1. 分类页已恢复主结构（`CTF学习笔记 / 密码学笔记 / 大模型安全 / 逆向学习笔记`）
2. 子结构可见（`比赛WP / 脚本 / 刷题记录 / 理论研究 / 密码学应用`）
3. `public/categories/index.html` 未检出 `2.比赛WP`、`4.脚本`、`LCG题单`

## 5. 后续避免再乱的建议（最小版）

以后请避免让我动以下部分（除非你明确授权）：

1. skill 与发布工作流实现细节（本轮目标外）
2. tools 目录下与前台结构无关脚本
3. 主题/导航/页面新增
4. 大规模历史文章重构

并固定发布原则：

1. 只把“影响前台结构的源文件”提交到 `hexo-src`；
2. 再由 Actions 自动部署；
3. 不再混用“本地有效但未入库”的临时状态。
