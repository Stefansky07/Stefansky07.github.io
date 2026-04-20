---
title: "ecc"
date: 2024-11-29 12:09:57
tags:
  - CTF
  - WP
  - Crypto
categories:
  - CTF学习笔记
  - 2.比赛WP
  - 校内金砖选拔赛
  - Crypto
source_note: "D:/1400note/1410CS学习笔记/cs学习笔记/CTF学习笔记/2.比赛WP/校内金砖选拔赛/Crypto/ecc.md"
---
# 一：题目类型
ECC加密
# 二：题目
```python
import ecdsa
import random

def ecdsa_test(dA,k):

    sk = ecdsa.SigningKey.from_secret_exponent(
        secexp=dA,
        curve=ecdsa.SECP256k1
    )
    sig1 = sk.sign(data=b'Hi.', k=k).hex()
    sig2 = sk.sign(data=b'hello.', k=k).hex()

    r1 = int(sig1[:64], 16)
    s1 = int(sig1[64:], 16)
    s2 = int(sig2[64:], 16)
    return r1,s1,s2

if __name__ == '__main__':
    n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
    a = random.randint(0,n)
    flag = 'flag{' + str(a) + "}"
    b = random.randint(0,n)
    print(ecdsa_test(a,b))

# (4690192503304946823926998585663150874421527890534303129755098666293734606680, 111157363347893999914897601390136910031659525525419989250638426589503279490788, 74486305819584508240056247318325239805160339288252987178597122489325719901254)

```
# 三：解题思路
椭圆曲线密码中的签名整数k相同攻击利用。
因为k值相同，所以r值也是相同的。
题目中给到了使用相同的k进行两次签名的结果，那根据：
```python
s1 = k^-1 (z1 + rda) mod n
s2 = k^-1 (z2 + rda) mod n
s1 - s2 = k^-1 (z1 - z2) mod n
K = (s1-s2)^-1 * (z1 -z2) mod n
```
得到k，最后再代入原式便能解出da了，即本题中的flag.
# 四：解题代码
```python
import sympy
from hashlib import sha1
from Cryptodome.Util.number import long_to_bytes , bytes_to_long
 
 
def calculate_private_key(r1, s1, s2, h1, h2, n):
    # 计算k值
    k = ((h1 - h2) * sympy.mod_inverse(s1 - s2, n)) % n
    # 计算私钥dA
    dA = (sympy.mod_inverse(r1, n) * (k * s1 - h1)) % n
    return dA
 
 
 
if __name__ == "__main__":
    # 定义椭圆曲线的参数
    n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
    # 签名中的r1, s1, s2值
    r1 = 4690192503304946823926998585663150874421527890534303129755098666293734606680
    s1 = 111157363347893999914897601390136910031659525525419989250638426589503279490788
    s2 = 74486305819584508240056247318325239805160339288252987178597122489325719901254
    h1 = bytes_to_long(sha1(b'Hi.').digest())
    h2 = bytes_to_long(sha1(b'hello.').digest())
    private_key = calculate_private_key(r1, s1, s2, h1, h2, n)
    print(f'flag{{{private_key}}}')

```


