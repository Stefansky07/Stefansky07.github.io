---
title: "LCG—1(异或）"
date: 2025-09-16 22:58:00
categories:
  - CTF学习笔记
  - 刷题记录
tags:
  - 题单
  - LCG
  - Crypto
disableNunjucks: true
---
# LCG—1(异或）

# 一：题目类型

LCG

# 二：题目

```python
from Crypto.Util.number import *
flag = b'Spirit{***********************}'

plaintext = bytes_to_long(flag)
length = plaintext.bit_length()

a = getPrime(length)
b = getPrime(length)
n = getPrime(length)

seed = 33477128523140105764301644224721378964069
print("seed = ",seed)
for i in range(10):
    seed = (a*seed+b)%n
ciphertext = seed^plaintext
print("a = ",a)
print("b = ",b)
print("n = ",n)
print("c = ",ciphertext)
# seed =  33477128523140105764301644224721378964069
# a =  216636540518719887613942270143367229109002078444183475587474655399326769391
# b =  186914533399403414430047931765983818420963789311681346652500920904075344361
# n =  155908129777160236018105193822448288416284495517789603884888599242193844951
# c =  209481865531297761516458182436122824479565806914713408748457524641378381493
```

# 三：解题思路

这道题的题意是:
他定义了一个变量叫plaintext，长字节字符串flag转换为整数得到的.
定义了一个整数seed = 33477128523140105764301644224721378964069
seed通过10次lcg转换之后再和plaintext二进制异或得到ciphertext
getPrime是根据输入length产生随机数的函数
思路:
想要得到flag就要知道plaintext
想要知道plaintext只能通过ciphertext = seed ^ plaintex这个表达式推出
而ciphertext == c我们知道，式子中的seed可以通过他给的初始seed,a,b,n运用算法lcg十次得到
然后根据异或的特性求解出plaintext，即plaintext = seed ^ ciphertext
(异或特性，c=a异或b，那么a=b异或c，或者b=a异或c)
解题代码如下

# 四：解题代码

```python
seed = 33477128523140105764301644224721378964069
a = 216636540518719887613942270143367229109002078444183475587474655399326769391
b = 186914533399403414430047931765983818420963789311681346652500920904075344361
n = 155908129777160236018105193822448288416284495517789603884888599242193844951
c = 209481865531297761516458182436122824479565806914713408748457524641378381493

for i in range(10):
    seed = (a*seed+b)%n
plaintext=seed^c
print(long_to_bytes(plaintext))


```

# 五：感悟




