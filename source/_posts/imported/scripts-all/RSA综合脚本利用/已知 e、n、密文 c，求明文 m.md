---
title: "已知 e、n、密文 c，求明文 m"
date: 2024-10-14 14:56:54
tags:
  - CTF
  - Script
categories:
  - CTF学习笔记
  - 4.脚本
  - RSA综合脚本利用
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/4.脚本/RSA综合脚本利用/已知 e、n、密文 c，求明文 m.md"
---
## 一：类型：
已知 e、n、密文 c，求明文 m
## 二：例一：
```python
import gmpy2
from Crypto.Util.number import *
from binascii import a2b_hex,b2a_hex
import binascii

e = 65537
c = 28767758880940662779934612526152562406674613203406706867456395986985664083182
#1.将n分解为p和q
p = 189239861511125143212536989589123569301
q = 386123125371923651191219869811293586459
n = p*q


phi = (p-1)*(q-1)
#2.求d
d = gmpy2.invert(e,phi)
#3.m=pow(c,d,n)
m = gmpy2.powmod(c,d,n)
print(binascii.unhexlify(hex(m)[2:]))
#binascii.unhexlify(hexstr):从十六进制字符串hexstr返回二进制数据
```



