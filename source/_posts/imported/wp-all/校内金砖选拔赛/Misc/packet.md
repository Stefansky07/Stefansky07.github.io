---
title: "packet"
date: 2024-11-29 12:53:13
tags:
  - CTF
  - WP
  - Misc
categories:
  - CTF学习笔记
  - 2.比赛WP
  - 校内金砖选拔赛
  - Misc
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/校内金砖选拔赛/Misc/packet.md"
---
# 一：题目类型
流量分析
# 二：题目
wireshark在手，简单的数据包分析就是小case。
# 三：解题思路
直接用CTF-neta一把梭：
![](/img/notes/Pasted-image-20241129125220.png)
发现一串base64加密，随波逐流后得出答案：
![](/img/notes/Pasted-image-20241129125301.png)


# 四：解题代码
```python
flag{7d6f17a4-2b0a-467d-8a42-66750368c249}
```



