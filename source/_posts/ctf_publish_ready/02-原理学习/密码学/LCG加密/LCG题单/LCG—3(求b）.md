---
title: "LCG—3(求b）"
date: 2025-09-19 00:12:00
categories:
  - CTF学习笔记
  - 刷题记录
tags:
  - 题单
  - LCG
  - Crypto
disableNunjucks: true
---
# LCG—3(求b）

# 一：题目类型

LCG

# 二：题目

```python
from Crypto.Util.number import *
flag = b'Spirit{*********************}'
plaintext = bytes_to_long(flag)
length = plaintext.bit_length()

a = getPrime(length)
seed = getPrime(length)
n = getPrime(length)

b = plaintext

output = []
for i in range(10):
    seed = (a*seed+b)%n
    output.append(seed)
ciphertext = seed

print("a = ",a)
print("n = ",n)
print("output1 = ",output[6])
print("output2 = ",output[7])

# a =  3227817955364471534349157142678648291258297398767210469734127072571531
# n =  2731559135349690299261470294200742325021575620377673492747570362484359
# output1 =  56589787378668192618096432693925935599152815634076528548991768641673
# output2 =  2551791066380515596393984193995180671839531603273409907026871637002460

```

# 三：解题思路

求flag相当于求plaintext，plaintext相当于求b，然后在看看我们已知的条件，我们知道a，知道n知道10次lcg中的第6次和第7次的结果，所以我们要根据已知的信息求b
用公式3：

$$
b=(X_{n+1}-aX_{n})\bmod m
$$

直接求出b
上代码

# 四：解题代码

```python
a =  3227817955364471534349157142678648291258297398767210469734127072571531
n =  2731559135349690299261470294200742325021575620377673492747570362484359
output1 =  56589787378668192618096432693925935599152815634076528548991768641673
output2 =  2551791066380515596393984193995180671839531603273409907026871637002460
b=(output2-a*output1)%n
plaintext=b
print(long_to_bytes(plaintext))


```

# 五：感悟




