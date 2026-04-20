---
title: "factor"
date: 2024-10-07 20:55:58
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
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/山河CTF/第一周/Crypto/factor.md"
---
# 一：题目类型
RSA；n分解出多素数因子
# 二：题目
```python
```Python
from Crypto.Util.number import *
import random
from enc import flag

m = bytes_to_long(flag)
e = 65537
def prod(iterable):
    result = 1
    for num in iterable:
        result *= num
    return result
prime_list = [getPrime(64) for _ in  range(10) ]
N = prod(prime_list)
p_list = random.sample(prime_list,7)
n = prod(p_list)
c = pow(m,e,n)
print(f"c = {c}")
print(f"N = {N}")
'''
c = 70627837774279494708724200501537771345952856938303903922249957814725849359425279512243605642377254942372898068998337958185033418948094
N = 172898935933891122925282182428259899241934564348163719535394581163162659124917584224525804826155141303434019727341046056794417271170112750820860370018949305864662116555024589584392553928637163
'''
```
# 三：解题思路与代码
### 方法一：
1. 我们先来分析一下这个代码运行过程：
```Python
  def prod(iterable):
    result = 1
    for num in iterable:
        result *= num
    return result   
```
首先它定义了一个prod函数，用来输出result，其等于各个数的乘积；
```Python
prime_list = [getPrime(64) for _ in  range(10) ]
N = prod(prime_list)
p_list = random.sample(prime_list,7)
n = prod(p_list)
```
然后是定义了一个名为prime_list的列表，其中含有十个随机生成的64位素数。N等于十个素数相乘的乘积，p_list为从十个素数中随机抽取的素数，n等于随机七个素数的乘积。
2. 分析完代码，我们来构建解题代码：首先我们利用yafu分解出十个素数：
![](/img/notes/Pasted-image-20241007205445.png)
3. 因为n是从N中分解出的十个素数中随机抽取七个素数组成的n，所以我们可以写一个函数，在prime_list中随机抽取七个素数组成n，然后计算n和phi；然后设计一个函数，如果解密出的M开头为'SHCTF’，那么返回flag，否则继续。所以我们可以给出代码：
```Python
from Crypto.Util.number import *
import random

c = 70627837774279494708724200501537771345952856938303903922249957814725849359425279512243605642377254942372898068998337958185033418948094
e = 65537
prime_list = [
    9842926695863385053,
    15004678769208751349,
    15134184916327586777,
    16819891579563296461,
    9822726903770343517,
    10997700674282327491,
    17537193756473520097,
    12435028582232828179,
    14969106136587376877,
    13041346041054784031
]

def prod(iterable):
    result = 1
    for num in iterable:
        result *= num
    return result
def generate_n(prime_list):
    selected_primes = random.sample(prime_list, 7)
    n = prod(selected_primes)
    return n, selected_primes
def calculate_phi(prime_list):
    phi = 1
    for prime in prime_list:
        phi *= (prime - 1)
    return phi
def calculate_d_and_m(n, phi, e, c):
    d = inverse(e, phi)
    m = pow(c, d, n)
    return d, m
while True:
    n, selected_primes = generate_n(prime_list)
    phi = calculate_phi(selected_primes)
    d, m = calculate_d_and_m(n, phi, e, c)
    if long_to_bytes(m).startswith(b'SHCTF'):
        print(f"Found correct n = {n}")
        print(f"phi(n) = {phi}")
        print(f"d = {d}")
        print(f"m = {long_to_bytes(m)}")
        break
    else:
        print("Incorrect m, trying again...")
```
# 四：感悟
多素数问题注意分解。phi等于各素数减一的乘积。






