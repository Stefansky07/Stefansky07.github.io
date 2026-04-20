---
title: "NSSCTF 2022 Spring Recruit factor"
date: 2025-06-22 15:31:00
disableNunjucks: true
---
# NSSCTF 2022 Spring Recruit factor

# 一：题目类型

[P05.基于N分解的题目](原理学习笔记/密码学/RSA加密算法/RSA基础篇/P05.基于N分解的题目.md)

# 二：题目

```python
n=240546297453496858231088405356129350257,你能把这个整数分解成两个素数的积吗？=> n = p * q
flag:NSSCTF{md5(min(p,q)+max(p,q))}
```

# 三：解题思路

其实很简单，但这个题提供了一种新思路用来调库，很有意思，记录一下

# 四：解题代码

```python
from xenny.ctf.crypto.modern.asymmetric.rsa.factor import attack
from hashlib import md5

n = 240546297453496858231088405356129350257
q,p = attack(n)
flag = md5(str(min(p,q)+max(p,q)).encode()).hexdigest()
print("NSSCTF{%s}"%flag)

```


