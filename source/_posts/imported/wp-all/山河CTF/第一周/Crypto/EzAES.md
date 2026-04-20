---
title: "EzAES"
date: 2024-10-07 20:52:39
tags:
  - CTF
  - WP
  - Crypto
categories:
  - CTF学习笔记
  - 2.比赛WP
  - 山河CTF
  - 第一周
  - Crypto
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/山河CTF/第一周/Crypto/EzAES.md"
---
# 一：题目类型
AES；签到题
# 二：题目
```python
```Python
from Crypto.Cipher import AES
import os

iv = os.urandom(16)
key = os.urandom(16)
my_aes = AES.new(key, AES.MODE_CBC, iv)
flag = open('flag.txt', 'rb').read()
flag += (16 - len(flag) % 16) * b'�'
c = my_aes.encrypt(flag)
print(c)
print(iv)
print(key)
'''
b'Kg\x94\xd1\x17)\xe5}\x85\xda/\xf3R\x02X\x85c\xc0zK-XtWL\xfb\xeb\xd1\xad\x1e\x87W\\\x1b<\xcd\x02\x1f\xd1"\xf1\n]\x01\x0bh&\xf7'
b'R\x1fB\xd66V\xc3M\xce4\x8d\xd8,\xf1"e'
b'<\x81L?\x0f\x96\x8e\xec|y\xfcWb\xe5\x05\x97'
```
# 三：解题思路与代码
### 方法一：
很简单的AES，直接解即可。
```Python
from Crypto.Cipher import AES
import os
from gmpy2 import*
from Crypto.Util.number import *

# 提供的值
c = b'Kg\x94\xd1\x17)\xe5}\x85\xda/\xf3R\x02X\x85c\xc0zK-XtWL\xfb\xeb\xd1\xad\x1e\x87W\\\x1b<\xcd\x02\x1f\xd1"\xf1\n]\x01\x0bh&\xf7'
iv = b'R\x1fB\xd66V\xc3M\xce4\x8d\xd8,\xf1"e'
key = b'<\x81L?\x0f\x96\x8e\xec|y\xfcWb\xe5\x05\x97'

aes = AES.new(key,AES.MODE_CBC,iv)
flag = aes.decrypt(c)
print(flag)
```
# 四：感悟
签到题争取拿一血






