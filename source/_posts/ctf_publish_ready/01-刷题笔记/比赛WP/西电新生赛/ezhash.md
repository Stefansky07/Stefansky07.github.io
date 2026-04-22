---
title: "ezhash"
date: 2025-04-06 11:09:00
categories:
  - CTF学习笔记
  - 比赛WP
tags:
  - WP
  - 西电新生赛
  - Crypto
  - SHA256
disableNunjucks: true
---
# ezhash

# 一：题目类型

sha256

# 二：题目

```python
from hashlib import sha256
from secret import flag, secrets
  
assert flag == b'moectf{' + secrets + b'}'
assert secrets[:4] == b'2100' and len(secrets) == 10
hash_value = sha256(secrets).hexdigest()
print(f"{hash_value = }")
# hash_value = '3a5137149f705e4da1bf6742e62c018e3f7a1784ceebcb0030656a2b42f50b6a'

```

# 三：解题思路

##### 方法一:

首先它给了前四位为2100，我们可以设计一个碰撞代码进行强行暴力破解，但这个方法执行太久。
代码如图：

```python
import hashlib
import itertools

from string import digits, ascii_letters, punctuation
alpha_bet=digits+ascii_letters+punctuation
strlist = itertools.product(alpha_bet, repeat=4)


sha256="3a5137149f705e4da1bf6742e62c018e3f7a1784ceebcb0030656a2b42f50b6a"
tail="2100"
xxxx=''

  
for i in strlist:

    data=i[0]+i[1]+i[2]+i[3]

    data_sha=hashlib.sha256((data+str(tail,encoding='utf-8')).encode('utf-8')).hexdigest()

    if(data_sha==str(sha256,encoding='utf-8')):
        xxxx=data
        break

print(xxxx)
```

###### 方法二

直接用网站进行查询：
[[MD5 在線免費解密 MD5、SHA1、MySQL、NTLM、SHA256、SHA512、Wordpress、Bcrypt 的雜湊 (hashes.com)](https://hashes.com/zh/decrypt/hash)]()
查阅出哈希值为：2100360168

# 四：解题代码

```


```

# 五：感悟

善用多种工具和网站


