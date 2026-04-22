---
title: "LCG—2(求初始seed）"
date: 2025-09-18 23:35:00
categories:
  - CTF学习笔记
  - 刷题记录
tags:
  - 题单
  - LCG
  - Crypto
disableNunjucks: true
---
# LCG—2(求初始seed）

# 一：题目类型

LCG

# 二：题目

```python
from Crypto.Util.number import *
flag = b'Spirit{*****************************}'

plaintext = bytes_to_long(flag)
length = plaintext.bit_length()

a = getPrime(length)
b = getPrime(length)
n = getPrime(length)
seed = plaintext
for i in range(10):
    seed = (a*seed+b)%n
ciphertext = seed

print("a = ",a)
print("b = ",b)
print("n = ",n)
print("c = ",ciphertext)

# a =  59398519837969938359106832224056187683937568250770488082448642852427682484407513407602969
# b =  32787000674666987602016858366912565306237308217749461581158833948068732710645816477126137
# n =  43520375935212094874930431059580037292338304730539718469760580887565958566208139467751467
# c =  8594514452808046357337682911504074858048299513743867887936794439125949418153561841842276
```

# 三：解题思路

根据题意求flag相当于求plaintext，求plaintext相当于求初始seed，我们知道lcg算法十次之后的seed=ciphertext=c，而c我们已知，我们还知道a，b，n。所以这道题要我们从lcg十次之后的seed推算出初始seed
用公式1：

$$
X_{n}=(a^{-1}X_{n+1}-b)\bmod m
$$

这里a-1是a相对于模数m的逆元，他也有公式

```python
MMI = lambda A, n,s=1,t=0,N=0: (n < 2 and t%N or MMI(n, A%n, t, s-A//n*t, N or n),-1)[n<1] #逆元计算

```

# 四：解题代码

```python
a =  59398519837969938359106832224056187683937568250770488082448642852427682484407513407602969
b =  32787000674666987602016858366912565306237308217749461581158833948068732710645816477126137
n =  43520375935212094874930431059580037292338304730539718469760580887565958566208139467751467
c =  8594514452808046357337682911504074858048299513743867887936794439125949418153561841842276
MMI = lambda A, n,s=1,t=0,N=0: (n < 2 and t%N or MMI(n, A%n, t, s-A//n*t, N or n),-1)[n<1] #逆元计算
ani=MMI(a,n) 
seed=c
for i in range(10):
    seed = (ani*(seed-b))%n
print(long_to_bytes(seed)
```

# 五：感悟




