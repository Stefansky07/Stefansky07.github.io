---
title: "Crypto_in_CTFRu_Men_Zhi_Bei_"
date: 2024-09-07 22:42:19
tags:
  - CTF
  - WP
categories:
  - CTF学习笔记
  - 2.比赛WP
  - 西电新生赛
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/西电新生赛/Crypto_in_CTFRu_Men_Zhi_Bei_.md"
---
# 一：题目类型
RSA类
RSA加密算法
# 二：题目
```
from Crypto.Util.number import bytes_to_long, getPrime
from secret import flag

p = getPrime(128)
q = getPrime(128)
n = p*q
e = 65537

m = bytes_to_long(flag)
c = pow(m, e, n)
print(f"n = {n}")
print(f"p = {p}")
print(f"q = {q}")
print(f"c = {c}")
  
'''
n = 40600296529065757616876034307502386207424439675894291036278463517602256790833
p = 197380555956482914197022424175976066223
q = 205695522197318297682903544013139543071
c = 36450632910287169149899281952743051320560762944710752155402435752196566406306
'''
```
# 三：解题思路
很简单的入门题目，因为已知n,p,q的值，所以直接求出phi，然后求出d与m，最后对m进行转化即可
# 四：解题代码
```
from Crypto.Util.number import *
from gmpy2 import *

n = 40600296529065757616876034307502386207424439675894291036278463517602256790833
p = 197380555956482914197022424175976066223
q = 205695522197318297682903544013139543071
c = 36450632910287169149899281952743051320560762944710752155402435752196566406306
e=65537

phi=(p-1)*(q-1)
d=inverse(e,phi)
m=pow(c,d,n)

print(long_to_bytes(m))

```
# 五：感悟
在做RSA类型的题目时，最重要的是求出p、q的值，许多题目都在这里求解。同时在最后不应忘了对m进行转化。
