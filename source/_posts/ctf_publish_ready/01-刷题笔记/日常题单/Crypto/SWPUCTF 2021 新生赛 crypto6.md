---
title: "SWPUCTF 2021 新生赛 crypto6"
date: 2025-07-31 05:42:00
disableNunjucks: true
---
# SWPUCTF 2021 新生赛 crypto6

# 一：题目类型

[Base64加密](原理学习笔记/密码学/古典加密/Base64加密.md)

# 二：题目

```python
var="************************************"
flag='NSSCTF{' + base64.b16encode(base64.b32encode(base64.b64encode(var.encode()))) + '}'
print(flag)

小明不小心泄露了源码，输出结果为：4A5A4C564B36434E4B5241544B5432454E4E32465552324E47424758534D44594C4657564336534D4B5241584F574C4B4B463245365643424F35485649534C584A5A56454B4D4B5049354E47593D3D3D，你能还原出var的正确结果吗？
```

# 三：解题思路

一把出，见[basecrack](原理学习笔记/密码学/一些工具/basecrack.md)

# 四：解题代码

![[Pasted image 20241021220306.png]]


